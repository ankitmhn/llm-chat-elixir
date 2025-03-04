def render(assigns) do
  ~H"""
   {live_render ChatBotLive, sticky: true}
   """
  end
end
BarLive do

def render(assigns) do
  ~H"""
   {live_render ChatBotLive, sticky: true}
   """
  end
end
end
George Arrowsmith
2:59 PM
live_session "foobar" do
  live "/foo", FooLive
  live "/bar", BarLive
end

George Arrowsmith
2:59 PM
live_session "foobar" do
  live "/foo", FooLive
  live "/bar", BarLive
end
George Arrowsmith
3:02 PM
https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#assign_async/3
George Arrowsmith
3:04 PM
https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#start_async/3

this one too
George Arrowsmith
3:09 PM
https://fly.io/phoenix-files/streaming-openai-responses/
https://www.hackwithgpt.com/blog/streaming-chatgpt-responses-with-phoenix-liveview/