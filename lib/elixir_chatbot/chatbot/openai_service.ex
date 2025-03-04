defmodule ElixirChatbot.OpenaiService do
  defp default_system_prompt do
    """
    You are a chatbot maps the users' request to the corresponding Elixir functions.
    You decide which function to call based on the user's request.
    You will be given a list of available functions and their descriptions in the tools section.
    You need to decide which function to call based on the user's request. If any of the required parameters are not provided, you should ask for them.
    You will then return the function name and its arguments.
    """
  end

  defp default_tools do
    [
      %{
        "type" => "function",
        "function" => %{
          "name" => "record_maintenance_task",
          "description" => "Record a maintenance task for a given aircraft",
          "parameters" => %{
            "type" => "object",
            "properties" => %{
              "aircraft_id" => %{
                "type" => "string"
              },
              "task_description" => %{
                "type" => "string"
              },
              "task_date" => %{
                "type" => "string"
              }
            },
            "required" => ["aircraft_id", "task_description", "task_date"]
          }
        }
      },
      %{
        "type" => "function",
        "function" => %{
          "name" => "get_aircraft_utilization",
          "description" => "Get the utilization of a given aircraft",
          "parameters" => %{
            "type" => "object",
            "properties" => %{
              "aircraft_id" => %{
                "type" => "string"
              }
            },
            "required" => ["aircraft_id"]
          }
        }
      }
    ]
  end

  def call(prompts, opts \\ []) do
    %{
      # "model" => "deepseek-r1:8b",
      "model" => "gpt-4o-mini",
      "messages" =>
        Enum.concat(
          [
            %{"role" => "system", "content" => default_system_prompt()}
          ],
          prompts
        ),
      "temperature" => 0.7,
      "tools" => default_tools()
    }
    |> Jason.encode!()
    |> request(opts)
    |> IO.inspect()
    |> parse_response()
  end

  defp parse_response({:ok, %Finch.Response{body: body}}) do
    messages =
      Jason.decode!(body)
      |> Map.get("choices", [])
      |> Enum.reverse()

    case messages do
      [%{"message" => message} | _] -> message
      _ -> %{}
    end
  end

  defp parse_response(error) do
    error
  end

  defp request(body, _opts) do
    Finch.build(:post, "https://api.openai.com/v1/chat/completions", headers(), body)
    # Finch.build(:post, "http://localhost:11434/api/generate", headers(), body)
    |> IO.inspect()
    |> Finch.request(ElixirChatbot.Finch)
  end

  defp headers do
    [
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{Application.get_env(:elixir_chatbot, :ai_api_key)}"}
    ]
  end
end
