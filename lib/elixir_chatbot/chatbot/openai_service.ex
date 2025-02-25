defmodule ElixirChatbot.OpenaiService do
  defp default_system_prompt do
    """
    You are a chatbot that only answers questions about the programming language Elixir.
    Answer short with just a 1-3 sentences.
    If the question is about another programming language, make a joke about it.
    If the question is about something else, answer something like:
    "I dont know, its not my cup of tea" or "I have no opinion about that topic".
    """
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
      "temperature" => 0.7
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
