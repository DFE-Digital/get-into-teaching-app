# Content Documentation/Guide

## Creating a Blog Post

Blog posts should be written in Markdown format using the following template as a guide:

#### article-title.md

```yaml
---
title: Article title
date: "2021-08-26"
images:
	an_image:
		path: "media/images/content/blog/image.jpg"
		thumbnail_path: "media/images/content/blog/thumbnails/image.jpg"
		alt: "A description of the image"
	another_image:
		path: "media/images/content/blog/another_image.jpg"
		alt: "A description of the image"
description: |-
	A brief description of the blog article.
keywords:
	- keyword 1
	- keyword 2
tags:
	- tag 1
	- tag 2
---

## Heading  

The blog content goes here. You can use [links](http://link.com) and other Markdown formatting, in addition to some custom Markdown syntax, such as including another image:

$another_image$
```

The first image (`an_image` in the above example) will be displayed at the top of the blog post and in the thumbnail image on the pages that list blog posts. 

Ideally you should also provide a `thumbnail_path` for the first image; this should be as close to `340px x 260px` as possible. If a `thumbnail_path` is not provided the `path` image will be used and scaled-down to display at a width of `170px`  (maintaining the image aspect ratio - thumbnail images should be `340px` wide to look clear on retina devices).

## Footers

The final paragraph in each blog post will be formatted so it stands out from the rest. It's intended to be used as a closing or summary paragrah that directs users on which step to take next if the post has inspired them. To reduce duplication there is a collection of generic ones listed in `app/views/blog/closing-paragraphs`.

To use a generic one without copying the content add the following key to the front matter, replacing the chosen variant as needed:

```yaml
closing_paragraph: enriching-the-lives-of-young-people
```

To add a new generic variant, copy and paste an existing one, give it an appropriate name `my-new-closing-paragraph.html.erb` and then reference it from your post:

```yaml
closing_paragraph: my-new-closing-paragraph
```
