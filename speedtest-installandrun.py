import argparse
import os


def main():
  """Runs the speedtest command."""

  parser = argparse.ArgumentParser(description="Runs the speedtest command.")
  parser.add_argument(
      "-s",
      "--server",
      type=int,
      help="The speedtest server to use.",
      default=3386,
  )
  args = parser.parse_args()

  if not os.path.exists("/usr/local/bin/speedtest"):
    print("Installing speedtest-cli...")
    os.system("sudo apt install speedtest-cli")

  print("Running speedtest...")
  os.system("speedtest --server {0}".format(args.server))


if __name__ == "__main__":
  main()
