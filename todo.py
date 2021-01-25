import json
import requests
import click
from pyfzf import pyfzf
import todoist
from pprint import pprint
import unicodedata


def get_han_count(text):
    count = 0
    for char in text:
        if unicodedata.east_asian_width(char) in "FWA":
            count += 2
        else:
            count += 1
    return count


def text_align(text, width=40, *, align=-1, fill_char=" "):
    fill_count = width - get_han_count(text)
    if fill_count <= 0:
        return text
    if align < 0:
        return text + fill_char * fill_count
    else:
        return fill_char * fill_count + text


def format_item(item):
    due = item["due"]["string"] if item["due"] else ""
    return "\t".join(map(text_align, [item["content"], due, str(item["id"])]))


@click.command()
@click.option("--filter", "-f", default="today|overdue")
def todo(filter: str):
    d = json.JSONDecoder()
    with open("/Users/matts966/.todoist.config.json") as config:
        token = d.decode(config.read())["token"]

    api = todoist.TodoistAPI(token)

    items = requests.get(
        "https://api.todoist.com/rest/v1/tasks",
        params={"filter": filter},
        headers={"Authorization": "Bearer %s" % token},
    ).json()
    items = map(format_item, items)
    fzf = pyfzf.FzfPrompt()
    try:
        result = fzf.prompt(items, "--multi --cycle")
    except Exception:
        exit(1)

    pprint(result)
    print()
    pprint(api.items.get_by_id(result[0].split()[-1]))


def main():
    todo()


if __name__ == "__main__":
    main()
