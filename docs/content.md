# Content Documentation/Guide

This documentation aims to be a reference for content editors that want to make changes to the Get into Teaching website. It contains details of how the content is structured, tips on editing content and specific guides on creating certain types of content.

## Table of Contents

1. [Finding a Page/Content to Edit](#finding-a-pagecontent-to-edit)
2. [Content Editing Tips/Info](#content-editing-tips-info)
	* [Frontmatter](#frontmatter)
	* [Links](#links)
	* [SEO](#seo)
	* [Prevent Indexing](#prevent-indexing)
	* [Adding a Document or Image](#adding-a-document-or-image)
	* [Jump Links](#jump-links)
	* [Calls to Action](#calls-to-action)
		* [Main Content](#main-content)
		* [Sidebar](#sidebar)
  * [Accessibility](#accessibility)
    * [iframe](#iframe)
3. [Creating a Blog Post](#creating-a-blog-post)
	* [Images](#images)
	* [Footers](#footers)

## Finding a Page/Content to Edit

When you want to edit content on the website the first step is to find out where that content resides in the [repository](https://github.com/DFE-Digital/get-into-teaching-app). 

The majority of web pages on the site are within the [/app/views/content](https://github.com/DFE-Digital/get-into-teaching-app/tree/master/app/views/content) directory; this reflects the top-level pages of the website (including the home page). If, for example, you wanted to edit the [career changers' stories](https://getintoteaching.education.gov.uk/my-story-into-teaching/career-changers) content you would edit the file [/app/views/content/my-story-into-teaching/career-changers.md](https://github.com/DFE-Digital/get-into-teaching-app/blob/master/app/views/content/my-story-into-teaching/career-changers.md). The structure here mimics the URL of the pages (the home page is a special case):

| URL      							| Content File 												|
| --------------------------------- | --------------------------------------------------------- |
| /      							| /app/views/content/home.md       							|
| /funding-your-training   			| /app/views/content/funding-your-training.md        		|
| /my-story-into-teaching/returners | /app/views/content/my-story-into-teaching/returners.md	|

Some web pages are more structurally complex than others and are made up of multiple Markdown files that get pulled into a single page. The home page is a good example of this; in addition to the main content page in [/app/views/content/home.md](https://github.com/DFE-Digital/get-into-teaching-app/blob/master/app/views/content/home.md) there are multiple other content files that reside under [/app/views/content/home/*.md](https://github.com/DFE-Digital/get-into-teaching-app/tree/master/app/views/content/home). If you can't find the content you wish to edit in the main file for that page, it's worth checking to see if it has a corresponding subdirectory with additional content files in.

If you can't find a corresponding file in the [/app/views/content](https://github.com/DFE-Digital/get-into-teaching-app/tree/master/app/views/content) directory for the web page you want to edit it may be a dynamically generated web page. These are constructed differently and the content may be in a template file or partial; your best bet here is to either search the whole repository for a bit of the text you wish to edit or to reach out to a developer to help you.

If you are looking to edit content associated with a form element in particular (for example, a label for a text input) then  you should look in the [translations file](https://github.com/DFE-Digital/get-into-teaching-app/blob/master/config/locales/en.yml). It's important to only change the text content in this file and not the Yaml keys that identify the content.

## Content Editing Info/Tips

The majority of pages on the website are formatted in Markdown, which is a lightweight markup language designed for creating and formatting text. 

There is a [Markdown Cheat Sheet](https://www.markdownguide.org/cheat-sheet/) that serves as a good reference on how to standard formatting, such as making something **bold** or *italic*. In conjunction with page frontmatter (see below) we can do some extra GiT-specific things in our Markdown, which this section aims to explain.

### Frontmatter

Whilst the content of a page can often be expressed in Markdown there are some additional aspects/metadata that need to be defined separately (such as the title of the page, SEO content, etc). We use frontmatter for this purpose, which is a section of Yaml at the top of each Markdown content file:

```yaml
---
single_value: "a single value"
multiple_values:
  - "one"
  - "two"
nested:
  value:
    here: "some nested value"
---
```

Knowing which frontmatter values are available for a page is not always obvious, but the best method is to look at a similar page and copy the frontmatter from there (or look at the page examples in this document).

### Links

Whilst links are just standard Markdown its worth noting that if you are linking internally to another web page on the GiT website you should only include the path, for example `[find an event](/events)` instead of `[find an event](https://getintoteaching.education.gov.uk/events)`. We do this so that the links work on all our test environments as well as production.

### SEO

In our frontmatter we can populate several values that are used for SEO:

```yaml
title: "A title for the page"
description: "A description of the page"
image: "path/to/image.png"
date: "2021-11-01"
```

Ideally all titles should be unique, descriptions should be < 160 characters and the image will most likely be visible when sharing web page links via social media platforms. If a date is specified it will be used as the last modified date for the sitemap entry.

### Prevent Indexing

Sometimes we don't want our content pages to be indexed by Google and other search engines (often when we're A/B testing the variant should not be indexed). You can achieve this by adding a `noindex: true` entry to the page frontmatter.

### Adding a Document or Image

If you need to include a link to a document or embed an image in your page content you'll need to first add the file to the repository. Any documents should be placed in `/app/webpacker/documents` and images in `/app/webpacker/images/content` (under a subdirectory if suitable). You can then reference the files in your Markdown content (note the paths used to reference here will differ to the location of the file - use `/media` instead of `/app/webpacker`):

```
[Download a document](media/documents/my-document.pdf)

![An image](media/images/content/my-image.jpg)
```

Images should be appropriately scaled and compressed prior to adding them to the website.

#### Alt text

The images used in the hero and on blog posts now pull their alt text from a central store. This allows us to set it once and include it wherever the image is used. The data is stored in `config/images.yml` and the format is as follows:

```yaml
"media/images/content/hero-images/0001.jpg":
  alt: "Maths teacher standing in front of a whiteboard with maths equations."
  variants:
    - "media/images/content/hero-images/0001--mobile.jpg"
    - "media/images/content/hero-images/0001--tablet.jpg"
```

The key (`"media/images/content/hero-images/0001.jpg"`) is the **primary** variant of the image, the full resolution one. Beneath it the following items are nested:

* `alt:` - the alt text for the image, wrapped in quotes
* `variants` - a list of **other versions of the same image**. The alternate versions can be thumbnails or crops and are considered alternates if the same `alt` text can be applied to them as the primary variant

### Jump Links

You can include jump links in the frontmatter of a page if it has a lot of content in order to make it easier for the user to navigate:

```yaml
---
jump_links:
  Tuition fee and maintenance loans: "#tuition-fee-and-maintenance-loans"
  Bursaries and scholarships: "#bursaries-and-scholarships"
  If you come from outside England: "#if-you-come-from-outside-england"
---

### Tuition fee and maintenance loans

Lots of text.

### Bursaries and scholorships

Lots of text.

# If you come from outside England

Lots of text.
```

The above example would render out as follows:

```
<img src="images/jump_link_examples.png" alt="Example Jump Links" style="width: 500px;">
```

### Calls to Action

On some pages we want to include one or more calls to action; instead of copy/pasting the HTML for these sections we can specify and configure them in the frontmatter and then reference them in our content.

#### Main Content

You can configure and reference calls to action as part of your main content:

```yaml
---
calls_to_action:
  chat:
    name: chat_online
    arguments:
    text: "Chat to one of our advisers"
  attachment:
    name: attachment
    arguments:
      text: Open attachment
      file_path: media/documents/a_report.pdf
      file_type: PDF
      published_at: 01 September 2020
  table:
    name: feature_table
    arguments:
      - "Row 1": "Value 1"
      "Row 2": "Value 2"
      - "A description of the table"
  generic:
    name: simple
    arguments:
      title: A title
      text: Some text
      icon: "icon-arrow"
      link_text: Link text
      link_target: "https://website.com/"
---

### Chat

$chat$

### Generic CTA

$generic$

### Attachment

$attachment$

### Table

$table$
```

The above example would render out as follows:

<img src="images/content_cta_examples.png" alt="Example Content CTAs" style="width: 500px;">

#### Sidebar

It is also possible to place multiple CTAs in the right column of the page:

```yaml
---
right_column:
  ctas:
    - title: Title
      text: Text
      link_text: Link text
      link_target: /path
      icon: icon-calendar
      hide_on_mobile: Yes
      hide_on_tablet: Yes
    - title: Other Title
      text: Other Text
      link_text: Other Link text
      link_target: /other/path
      icon: icon-calendar
      hide_on_mobile: Yes
      hide_on_tablet: Yes
---

This is the main content.
```

The above example would render out as follows:

<img src="images/sidebar_cta_examples.png" alt="Example Sidebar CTAs" style="width: 500px;">

### Accessibility

#### iframe

When adding an iFrame elemet as part of Markdown content or a HTML page we should ensure it has an appropriate `title` attribute that explains the contents of the iFrame (in most of our cases we are showing a video). For example:

```
<iframe 
  title="A video about returning to teaching"
  ...
></iframe>
```

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

### Images

The first image (`an_image` in the above example) will be displayed at the top of the blog post and in the thumbnail image on the pages that list blog posts.

Ideally you should also provide a `thumbnail_path` for the first image; this should be as close to `340px x 260px` as possible. If a `thumbnail_path` is not provided the `path` image will be used and scaled-down to display at a width of `170px` (maintaining the image aspect ratio - thumbnail images should be `340px` wide to look clear on retina devices).

### Content

Introduction paragraphs (where used) should go underneath the first image rather than above it. Use normal text rather than italics for the introduction paragraph as this is better for accessibility. If it is necessary to separate this introduction paragraph from subsequent paragraphs, you can use a heading.

Biographical information about the author should go at the end of the article above the footer, with a heading of 'About the author'.

### Footers

The final paragraph in each blog post will be formatted so it stands out from the rest. It's intended to be used as a closing or summary paragrah that directs users on which step to take next if the post has inspired them. To reduce duplication there is a collection of generic ones listed in `app/views/blog/closing-paragraphs`.

To use a generic one without copying the content add the following key to the front matter, replacing the chosen variant as needed:

```yaml
closing_paragraph: enriching-the-lives-of-young-people
```

To add a new generic variant, copy and paste an existing one, give it an appropriate name `my-new-closing-paragraph.html.erb` and then reference it from your post:

```yaml
closing_paragraph: my-new-closing-paragraph
```
