import os
import json
import requests
import click
from pyfzf import pyfzf
import todoist
from pprint import pprint


def format_item(item):
    due = item["due"]["string"] if item["due"] else ""
    return "{:<10}\t{:<10}\t{}".format(item["id"], due, item["content"])


@click.command()
@click.option("--filter", "-f", default="today|overdue")
def todo(filter: str):
    d = json.JSONDecoder()
    with open(
        os.path.join(os.environ["HOME"], ".todoist.config.json")
    ) as config:
        token = d.decode(config.read())["token"]

    items = requests.get(
        "https://api.todoist.com/rest/v1/tasks",
        params={"filter": filter},
        headers={"Authorization": "Bearer %s" % token},
    ).json()
    items = map(format_item, items)
    fzf = pyfzf.FzfPrompt()

    print(fzf)

    try:
        result = fzf.prompt(
            items,
            "--multi --cycle --preview 'curl --silent \
                    https://api.todoist.com/sync/v8/items/get -d token="
            + token
            + " -d item_id=$(echo {} | cut -f1) | jq | bat --color=always'",
        )
    except Exception:
        exit(1)

    pprint(result)
    print()
    api = todoist.TodoistAPI(token)
    pprint(api.items.get_by_id(result[0].split()[-1]))


def main():
    todo()


if __name__ == "__main__":
    main()
