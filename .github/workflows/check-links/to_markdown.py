import argparse
import csv


def gen_report(csvpath, mdpath):
    with open(csvpath, "r") as file:
        reader = csv.DictReader(file)
        links = [row for row in reader]
        links = sorted(links, key=lambda x: x["referer"])

    if not links:
        return None

    with open(mdpath, "w") as file:
        file.write(f"Broken Links\n")
        file.write(f"---")

        referer = ""
        for link in links:
            if link["referer"] != referer:
                referer = link["referer"]
                domain = referer.split("//")[1]
                file.write(f"\n\n**[{domain}]({referer})**  \n")
            file.write(
                f"- Failed: HTTP Status {link['status']} at [{link['link_text']}]({link['url']})  \n"
            )


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Generate markdown report for a broken links search"
    )

    parser.add_argument(
        "--csvpath", default="./report.csv", type=str, help="csv input filepath"
    )
    parser.add_argument(
        "--mdpath", default="./report.md", type=str, help="markdown output filepath"
    )

    args = parser.parse_args()

    gen_report(args.csvpath, args.mdpath)
