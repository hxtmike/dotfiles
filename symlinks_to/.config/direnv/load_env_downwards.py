from pathlib import Path
from dotenv import load_dotenv

def load_dotenv_downward(
    start: Path | None = None,
    stop_at: Path | None = Path.home(),
) -> None:
    start = (start or Path.cwd()).resolve()
    stop_at = (stop_at or Path.home()).resolve()

    env_files = []
    cur = start

    while True:
        env_path = cur / ".env"
        if env_path.is_file():
            env_files.append(env_path)

        if cur == stop_at or cur.parent == cur:
            break
        cur = cur.parent

    for env in reversed(env_files):
        load_dotenv(env, override=True)
