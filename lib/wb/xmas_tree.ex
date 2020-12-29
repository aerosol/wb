defmodule WB.XmasTree do
  def success(msg, deets \\ "") do
    [
      IO.ANSI.green(),
      "[OK] #{msg} ",
      IO.ANSI.reset(),
      deets
    ]
    |> IO.puts()
  end

  def info(msg, deets \\ "") do
    [
      IO.ANSI.yellow(),
      "[INFO] #{msg} ",
      IO.ANSI.reset(),
      deets
    ]
    |> IO.puts()
  end

  def warn(msg, deets \\ "") do
    [
      IO.ANSI.red(),
      "[WARN] #{msg} ",
      IO.ANSI.reset(),
      deets
    ]
    |> IO.puts()
  end
end
