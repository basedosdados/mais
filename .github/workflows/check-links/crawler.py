from scrapy.item import Field, Item
from scrapy.linkextractors import LinkExtractor
from scrapy.selector import Selector
from scrapy.spiders import CrawlSpider, Rule


class LinkStatus(Item):
    url = Field()
    status = Field()
    referer = Field()
    link_text = Field()


class LinkSpider(CrawlSpider):
    name = "link-checker"
    report_if = set(range(400, 600))
    handle_httpstatus_list = list(report_if)

    start_urls = ["http://basedosdados.github.io/mais"]

    rules = [
        Rule(
            LinkExtractor(allow="basedosdados\.github\.io.*"),
            callback="parse",
            follow=True,
        ),
        Rule(LinkExtractor(), callback="parse", follow=False),
    ]

    def parse(self, response):
        if response.status in self.report_if:
            item = LinkStatus()
            item["url"] = response.url
            item["status"] = response.status
            item["link_text"] = response.meta["link_text"].strip()
            item["referer"] = response.request.headers.get(
                "Referer", self.start_urls[0]
            )
            yield item
        yield None


# References
# https://gist.github.com/mdamien/7b71ef06f49de1189fb75f8fed91ae82
# https://matthewhoelter.com/2018/11/27/finding-broken-links-on-website.html
# https://dev.to/pjcalvo/broken-links-checker-with-python-and-scrapy-webcrawler-1gom
