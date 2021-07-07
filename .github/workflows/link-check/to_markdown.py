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
    gen_report("./report.csv", "./report.md")
