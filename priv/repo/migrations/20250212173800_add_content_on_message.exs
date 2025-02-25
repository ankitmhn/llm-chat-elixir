defmodule ElixirChatbot.Repo.Migrations.AddContentOnMessage do
  use Ecto.Migration

  def change do
    alter table(:chatbot_messages) do
      add :content, :string
    end
  end
end
