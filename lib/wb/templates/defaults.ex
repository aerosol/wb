defmodule WB.Templates.Defaults do
  @external_resource "priv/_main.html"
  @external_resource "priv/_index.html"
  @external_resource "priv/_single.html"
  @external_resource "priv/_static/css/mvp.css"

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
    unquote(File.read!("priv/_static/css/mvp.css"))
  end

  def hello(layout_root) do
    """
    # Welcome to Writer's Block!

    1. Drop markdown files into `#{Path.absname(layout_root)}` directory
    2. Regenerate the site with `wb gen`

    Have fun!

    If in doubt, check out the [docs](https://mtod.org/wb).
    """
  end
end
