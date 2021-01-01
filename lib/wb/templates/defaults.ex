defmodule WB.Templates.Defaults do
  def main() do
    unquote(File.read!("priv/_main.html"))
  end

  def index() do
    unquote(File.read!("priv/_index.html"))
  end

  def single() do
    unquote(File.read!("priv/_single.html"))
  end

  def stylesheet() do
    unquote(File.read!("priv/_static/css/style.css"))
  end

  def hello(layout_root) do
    """
    # Welcome to Writer's Block!

    Drop markdown files into `#{Path.absname(layout_root)}` directory and you're good to go. Have fun!
    """
  end
end
