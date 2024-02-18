#!/usr/bin/env python

import argparse

from ruamel.yaml import YAML


def read_config(file_path: str):
    yaml = YAML(typ="safe")
    with open(file_path) as f:
        return yaml.load(f)


def create_translation_source(config, source_path, source_language):
    for plugin in config["plugins"]:
        if type(plugin) == dict and "i18n" in plugin:
            for lang in plugin["i18n"]["languages"]:
                print(lang["locale"])

    nav_config = []
    for _entry in config["nav"]:
        nav_config.append({v: k for k, v in _entry.items()})

    tx_cfg = {"nav": nav_config}

    tx_cfg["theme"] = {"palette": []}
    for palette in config["theme"]["palette"]:
        tx_cfg["theme"]["palette"].append(
            {"toggle": {"name": palette["toggle"]["name"]}}
        )

    with open(source_path, "w") as f:
        yaml = YAML()
        yaml.dump({source_language: tx_cfg}, f)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-c", "--config_path", default="mkdocs.yml", help="mkdocs.yml complete path"
    )
    parser.add_argument(
        "-s", "--source_language", default="en", help="source language of the config"
    )

    subparsers = parser.add_subparsers(title="command", dest="command")

    # create the parser for the create_source command
    parser_source = subparsers.add_parser(
        "create_source", help="Creates the source file to be translated"
    )
    parser_source.add_argument(
        "translation_file_path", help="Translation file to create"
    )

    # create the parser for the update_config command
    parser_update = subparsers.add_parser(
        "update_config",
        help="Updates the mkdocs.yaml config file from the downloaded translated files",
    )

    args = parser.parse_args()
    cfg = read_config(args.config_path)

    if args.command == "create_source":
        create_translation_source(cfg, args.translation_file_path, args.source_language)
