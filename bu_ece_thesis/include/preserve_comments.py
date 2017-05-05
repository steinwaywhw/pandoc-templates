#!/usr/bin/env python3

from panflute import *


def convertComment(elem, doc):
	if isinstance(elem, RawBlock) and elem.format in ["html", "html5"]:
		elem.text = elem.text.replace("<!--", "%").replace("-->", "")
		elem.format = "latex"

if __name__ == '__main__':
	toJSONFilter(convertComment)