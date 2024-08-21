# Content Documentation/Guide

This documentation aims to be a reference for content editors that want to make changes to the Get into Teaching website. It contains details of how the content is structured, tips on editing content and specific guides on creating certain types of content.

## Table of Contents

1. [Setting up Codespaces and Github](#getting-started)
2. [Finding a Page/Content to Edit](#finding-a-pagecontent-to-edit)
3. [Content Editing Tips/Info](#content-editing-tips-info)
	* [Headings](#headings)
	* [Frontmatter](#frontmatter)
    * [Breadcrumbs](#breadcrumbs)
	* [Links](#links)
	* [SEO](#seo)
	* [Prevent Indexing](#prevent-indexing)
	* [Adding a Document or Image](#adding-a-document-or-image)
	* [Calls to Action](#calls-to-action)
		* [Main Content](#main-content)
		* [Sidebar](#sidebar)
	* [Accessibility](#accessibility)
		* [iframe](#iframe)
	* [Inset text](#inset-text)
	* [YouTube Video](#youtube-video)
	* [Hero](#hero)
	* [Values](#values)
4. [Creating a Blog Post](#creating-a-blog-post)
	* [Images](#images)
	* [Footers](#footers)
5. [Navigation](#navigation)
	* [Main Navigation](#main-navigation)
	* [Category Pages](#category-pages)
6. [Build errors](#build-errors)
7. [Internship providers](#internship-providers)
8. [Creating a new page](#creating-a-new-page)
9. [Preview a change](#preview-a-change)
10. [Saving a change](saving-a-change)
11. [If you add something to the wrong branch](wrong-branch)
12. [Redirect URLs](redirect-urls)
13. [Finding links on the site](links-site)

## Setting up Codespaces and Github

You will need to download and set up an account on Github and Visual Studio Code with help from the team. Once you're ready:

1. Go to the master branch link: https://github.com/DFE-Digital/get-into-teaching-app
2. Select the green button '<> Code' and create a branch
3. This will start 'setting up a Codespace'
4. Once this is loaded, go to the top left hand corner and select the three horizontal lines - this will open a drop down
5. Select 'Open in VS Code Desktop'
6. This will open the file on Visual Studio Code
7. When you run a codespace it will make up a branch name: **when you next go on to github and want to run a codespace, you should use the same branch every time. You do not need to make a new one every time.**

### Tips
- Most of the content sits under 'app > views > content'
- When starting a new branch, make sure to always start with the latest version of 'master' by starting from this link: https://github.com/DFE-Digital/get-into-teaching-app
- In the folders, blue arrow icons are the pages and the content, the red <> icons are components
- Markdown tutorial is useful when learning to write content in Github https://www.markdowntutorial.com/



## Finding a Page/Content to Edit

When you want to edit content on the website the first step is to find out where that content resides in the [repository](https://github.com/DFE-Digital/get-into-teaching-app).

The majority of web pages on the site are within the [/app/views/content](https://github.com/DFE-Digital/get-into-teaching-app/tree/master/app/views/content) directory; this reflects the top-level pages of the website (including the home page). If, for example, you wanted to edit [the 'how to apply for teacher training' blog post](https://getintoteaching.education.gov.uk/blog) content you would edit the file [/app/views/content/blog/how-to-apply-for-teacher-training.md](https://github.com/DFE-Digital/get-into-teaching-app/blob/master/app/views/content/blog/how-to-apply-for-teacher-training.md). The structure here mimics the URL of the pages (the home page is a special case):

| URL                                     | Content File                                                 |
| ---------------------------------       | ---------------------------------------------------------    |
| /                                       | /app/views/content/home.md                                   |
| /funding-and-support                    | /app/views/content/funding-and-support.md                  |
| /blog/how-to-apply-for-teacher-training | /app/views/content/blog/how-to-apply-for-teacher-training.md |

Some web pages are more structurally complex than others and are made up of multiple Markdown files that get pulled into a single page. The home page is a good example of this; in addition to the main content page in [/app/views/content/home.md](https://github.com/DFE-Digital/get-into-teaching-app/blob/master/app/views/content/home.md) there are multiple other content files that reside under [/app/views/content/home/*.md](https://github.com/DFE-Digital/get-into-teaching-app/tree/master/app/views/content/home). If you can't find the content you wish to edit in the main file for that page, it's worth checking to see if it has a corresponding subdirectory with additional content files in.

If you can't find a corresponding file in the [/app/views/content](https://github.com/DFE-Digital/get-into-teaching-app/tree/master/app/views/content) directory for the web page you want to edit it may be a dynamically generated web page. These are constructed differently and the content may be in a template file or partial; your best bet here is to either search the whole repository for a bit of the text you wish to edit or to reach out to a developer to help you.

If you are looking to edit content associated with a form element in particular (for example, a label for a text input) then  you should look in the [translations file](https://github.com/DFE-Digital/get-into-teaching-app/blob/master/config/locales/en.yml). It's important to only change the text content in this file and not the Yaml keys that identify the content.

## Content Editing Info/Tips

The majority of pages on the website are formatted in Markdown, which is a lightweight markup language designed for creating and formatting text.

There is a [Markdown Cheat Sheet](https://www.markdownguide.org/cheat-sheet/) that serves as a good reference on how to standard formatting, such as making something **bold** or *italic*. In conjunction with page frontmatter (see below) we can do some extra GiT-specific things in our Markdown, which this section aims to explain.

**You'll need to check if the page is in markdown or html** as some pages have been coded in html. Depending on which it is you need to make sure you're consistent, so for e.g. if you have a section in markdown you can't add a link using html code it needs to also be in markdown.

### Headings

Where possible we should use the `HeadingComponent` to render a heading; especially if it contains a caption. For example:

```
render HeadingComponent.new(
  heading: "My heading",
  tag: :h2,
  heading_size: :l,
  caption: "My caption",
  caption_size: :m
)
```

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

### Breadcrumbs

Breadcrumbs are included by default on most layouts. You can chose to optionally disable breadcrumbs by setting the following in the front matter:

```yaml
---
breadcrumbs: false
---
```

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
[Download a document](static/documents/my-document.pdf)

![An image](static/images/content/my-image.jpg)
```

Images should be appropriately scaled and compressed prior to adding them to the website.

#### Alt text

The images used in the hero and on blog posts now pull their alt text from a central store. This allows us to set it once and include it wherever the image is used. The data is stored in `config/images.yml` and the format is as follows:

```yaml
"static/images/content/hero-images/0032.jpg":
  alt: "An English teacher talking to pupils in a classroom."
  variants:
    - "static/images/content/hero-images/0032--mobile.jpg"
    - "static/images/content/hero-images/0032--tablet.jpg"
```

The key (`"static/images/content/hero-images/0032.jpg"`) is the **primary** variant of the image, the full resolution one. Beneath it the following items are nested:

* `alt:` - the alt text for the image, wrapped in quotes
* `variants` - a list of **other versions of the same image**. The alternate versions can be thumbnails or crops and are considered alternates if the same `alt` text can be applied to them as the primary variant

### Calls to Action

On some pages we want to include one or more calls to action; instead of copy/pasting the HTML for these sections we can specify and configure them in the frontmatter and then reference them in our content.

#### Main Content

You can configure and reference calls to action as part of your main content:

```yaml
---
calls_to_action:
  chat:
    name: chat
    arguments: {}
  attachment:
    name: attachment
    arguments:
      text: Open attachment
      file_path: static/documents/a_report.pdf
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

### Accessibility

#### iframe

When adding an iFrame elemet as part of Markdown content or a HTML page we should ensure it has an appropriate `title` attribute that explains the contents of the iFrame (in most of our cases we are showing a video). For example:

```
<iframe
  title="A video about returning to teaching"
  ...
></iframe>
```

### Inset text

If you need to call out something important in a page and differentiate it from the surrounding text, you can use the inset text component. Specify the component in the frontmatter and then include it anywhere in the page. We use the purple colour for non-UK content and the purple-white colour for non-UK content on a grey background.

```yaml
---
inset_text:
  important-content:
    header: Optional title header
    title: Optional title
    text: Text that can contain <a href="#">links</a>
    color: yellow|grey|purple|purple-white
---

# My page

$important-content$
```
If you need to insert an inset text component in an erb file:

```yaml
<%= render Content::InsetTextComponent.new(
  header: "Non-UK citizens:",
  text: "You can call us on <a href=\"tel:+448003892500\">+44 800 389 2500</a>, or use the free live chat service. Calls will be charged at your country's standard rate.",
  color: "purple-white"
  ) %>
```


Use this component for non-UK content when:  

* it will be the only non-UK component on the page  
* you need to call out a short amount of non-UK content  
* you need to call out non-UK content within another component, for example the funding widget 

If using this component for non-UK content: 

* always use the purple colour (or purple-white on a grey background) 
* the header must be ‘Non-UK citizens:’ 

If you need to call out non-UK content several times on a page, or you need to call out a singular large amount of non-UK content, you can use the details expander.  

### Details expander for non-UK content

You can use the details expander component to highlight content for a non-UK audience, which is rendered as an expandable inset box. Specify the component in the frontmatter and then include it anywhere in the page. Only the title and text parameters are required:

```yaml
---
expander:
  check-your-qualifications:
    title: Check your qualifications
    text: If you're a non-UK citizen and need a visa to come to the UK to train to teach, you need to make sure the course you’re applying for sponsors visas.
    link_title: Find out more about how to apply for a visa to train to teach in England
    link_url: /non-uk-teachers/visas-for-non-uk-trainees

  another-example:
    title: Another example
    text: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ullamcorper, purus eget lobortis maximus, diam leo consequat tellus, in interdum odio nisl sed nibh.
    header: Non-UK citizens
    expanded: true
---


# My page

$check-your-qualifications$

$another-example$

```
If you need to insert an expander into an erb file:

```yaml
<%= render Content::ExpanderComponent.new(
    title: "check your qualifications",
    text: "If you have qualifications from outside the UK, you'll need to show that they meet the standards set for teacher training in England.",
    link_title: "You can get help comparing English and international qualifications.",
    link_url: "/non-uk-teachers/non-uk-qualifications",
  ) %>
```

### YouTube video

To add a YouTube video to your content you need to know the video ID. You can find this out by visiting the video on [youtube.com](https://www.youtube.com/) and looking in the address bar of your browser (it is in the format `watch?v=<video_id>`).

Once you have the video ID you can declare the video in the frontmatter of your page and reference it in the content:

```yaml
---
youtube_video:
  return-to-teaching-advisers-video:
    id: 2NrLm_XId4k
    title: A video about what Return to Teaching Advisers do
---

# My page

$return-to-teaching-advisers-video$
```

### Hero

Most of the web pages on the site have a hero section that can be customised in frontmatter; the hero section is at the top of the page and usually consists of a large image, heading and some text - these are the available options, though not all are required:

```yaml
heading: Hero heading
subtitle: Hero subtitle
subtitle_link: /subtitle/link
subtitle_button: Button text
image: /path/to/image.jpg
title_paragraph: Paragraph of text
title_bg_color: yellow
hero_bg_color: white
hero_blend_content: true
```

### Values

You can use the Values system to maintain key values (e.g. salaries, dates, fees etc) in a single file, and then use these values throughout the site's content. Set up a list of values in one or more YML files stored in the `config/values/` folder (or sub-folder), for example `config/values/dates.yml`:

```yaml
dates:
  example:
    opening: 1st September 2024

dates_example_closing: 31/12/2024
```

These values can then be used in markdown files by referencing the value as `$value_name$`, e.g. `$dates_example_opening$` or `$dates_example_closing$`. Note that structured composite keys will be flattened to a single key.

An example markdown implementation might be:

```markdown
# Useful dates

The closing date for applications is $dates_example_closing$. It is important to submit your application in good time.
```

Values can be used in ERB templates using `<%= value :value_name %>` (or as a shorthand, `<%= v :value_name %>`). 

An example ERB implementation might be:

```html
<h1>Useful dates</h1>
<p>
  The opening date for applications is <%= v :dates_example_opening %>.	
</p>
```

Values can also be utilised in the YAML-based internationalisation (I18n) translation definitions as used in the funding widget. The value should be specified as `%{value_name}`.

An example YAML implementation might be: 

```yaml
en:
  funding_widget:
    subjects:
      maths:
        name: "Maths"
        group: "Secondary"
        sub_head: "Maths - starting salary: %{salaries_example_min}"
        funding: "The opening date for applications is %{dates_example_opening} so get ready to apply soon."
```

A list of the current values available on the site can be viewed at the `/values` endpoint.

Values should be named using only _lowercase_ characters `a` to `z`, the numbers `0` to `9`, and the underscore `_` character. Unsupported characters such as the hyphen `-` are converted into underscores.

## Creating a Blog Post

Blog posts should be written in Markdown format using the following template as a guide:

#### article-title.md

```yaml
---
title: Article title
date: "2021-08-26"
images:
an_image:
  path: "static/images/content/blog/image.jpg"
  thumbnail_path: "static/images/content/blog/thumbnails/image.jpg"
  alt: "A description of the image"
another_image:
  path: "static/images/content/blog/another_image.jpg"
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

The first image (`an_image` in the above example) will be displayed at the top of the blog post and in the thumbnail image on the pages that list blog posts. The main blog image should ideally be `1464px x 1100px` to fit the available space in the template at a reasonable resolution.

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

### Tags

We have a whitelist of available blog tags in `/config/tags.yml` - if you try to add a tag not contained within this list you will receive an error message on the blog post page and our test suite will fail (preventing you from deploying your blog post). If you need a tag not already in the whitelist, add it to the `tags.yml` before referencing it in your blog post.

## Navigation

There are two types of navigation components on the website; the main navigation (at the top of every page) and category pages (a page where the navigation component is in the content as a group of cards). They are both configured in a similar way.

#### Main Navigation

The main navigation appears at the top of every page and contains links to key pages of the website. For a page to appear in the main navigation it must be declared as a "root" page, which means it is in the `content` directory and not one of its subdirectories. For example `/content/my-important-page.md` can appear in the main navigation, however `/content/subdirectory/my-important-page.md` cannot.

In order to have a page appear in the main navigation it must contain the following frontmatter:

```yaml
navigation: 20
navigation_title: Train to be a teacher
navigation_path: "/train-to-be-a-teacher"
```

The `navigation_title` is the text of the link that will appear in the main navigation and the `navigation_path` is where the link will take the user. The `navigation` attribute determines the order of the links within the main navigation; ascending order for left to right.

As an example, if there is a navigation page with `navigation: 13` and you want your new page to appear immediately after it, then you could use `navigation: 14` (if another page is already using `14` you can use decimals for greater flexibility, so `13.1`).

#### Category Pages

A category page displays a number of cards that the user can click on in order to navigate to related content. The category page itself must specify a specific layout in the frontmatter:

```yaml
layout: "layouts/category"
```

You can then define the cards/pages within a subfolder matching the main category page. For example, your folder structure may look like:

```
/main-category-page.md
/main-category-page/first-page.md
/main-category-page/second-page.md
```

In order for the pages to appear as cards on the main category page they must have navigational attributes defined in the frontmatter:

```yaml
navigation: 1
navigation_title: Title that appears on the card
navigation_description: A brief description that will appear in the card for this page
```

The `navigation` attribute determines the order of the cards on the page (lower values appear first/higher up the page). The `navigation_description` will appear within the card for this page below a heading, which will match the `navigation_title` (if set), `heading` (if `navigation_title` is not set) or `title` (if neither `navigation_title` nor `heading` are set) from the page frontmatter.

A category page can have multiple sections of related cards. To have cards grouped in a separate section and under a different heading you can use the `subcategory` attribute in the frontmatter of the related pages:

```yaml
subcategory: Grouped cards
```

A category can also contain 'content', which is rendered after the cards and can include complex HTML partials. You specify the partials in the frontmatter under the `content` key:

```yaml
content:
  - content/main-category-page/partial
```

In this example the partial file would be declared in `content/main-category-page/_partial.html.erb` (note the underscore prefix and the file type). Its likely that a developer will create the partial, but using the frontmatter you can easily pull in and re-arrange existing content partials.

## Build errors

When editing content you may find that the pull request build fails, meaning you can't merge your changes. In an effort to make the debugging process easier and more self-servable we are detailing common failures below and how to resolve them.

The first step is finding out what the build error is:

* Scroll down to the 'checks' section of your pull request.
* Find the check that has failed (it will have a red cross next to it and there may be multiple) .
* Open the 'details' link next to the check(s) that have failed and you should be automatically taken to the failure details, often highlighted in red.
* Cross-reference this error with the errors below to discover the issue and resolution.

### A link to a heading on the same page is broken

#### Example error:

```
expected to find xpath "//*[@id='other-types-of-visa-you-can-use-to-work-as-a-teacher-in-england']" but there were no matches
```

#### Description

This error means there is a hyperlink in your content that is linking to a heading on the same page that cannot be found. The heading may have been renamed or removed.

#### Resolution

The hyperlink must match the heading title exactly and be suffixed with a hash, for example a heading of `This is a heading` should be linked to using the markdown `[my link](#this-is-a-heading)`. If you are linking to a heading on another page, ensure the filename matches the path exactly and has a leading slash `/`.

### The filename contains invalid characters

#### Example error:

```
expected "/non-uk-teachers/fees-and-funding-for-non-UK-trainees" to match /^[a-z0-9\-\/]+$/
```

#### Description

This error means the filename contains one or more invalid characters.

#### Resolution

Check your filename only contains lower case characters, numbers and underscores.

## Internship providers

#### Warning! Do not edit the `teaching-internship-providers.md` page directly.

Unlike the other content pages the internship providers page is a fully generated page. 
This is because occasionally we are sent a new spreadsheet to update the list of internship providers on the `teaching-internship-providers.md` page and the numbers can be large, and need to be grouped by provider region and sorted, which would be a large and time consuming manual task. We have a rake task to make this easy to do, but this means it should not be edited directly. Instead any changes to content for the page should be made to the `lib/tasks/support/teaching-internship-providers.md.erb` file and then the page should be regenerated:

- Run `bundle exec rake teaching_internship_providers:generate` in your terminal.

When updating not just the text content within the file, but the actual list of providers (which will be provided as an XLSX file), you will need to update the CSV file that the rake task uses to generate the page. To do this:
- Export the XLSX to CSV with filename `internship_providers.csv`
- Place it in the `lib/tasks/support` directory.
- Run `bundle exec rake teaching_internship_providers:generate`.


## Creating a new page

1. **Make sure you start by creating a new branch on master**
To do this you will need to
	- always open Visual Studio Code from https://github.com/DFE-Digital/get-into-teaching-app and open from the green code button
	- once Visual Studio Code is open, click the search bar and select 'Create new branch'
	- type in the name of your new branch and press enter
	- if your branch has been created, it will appear as a name in the bottom left hand corner, next to the blue tab of the codespace name 

  **Make sure you're in the new branch when you create the doc and not master as you can't make changes to the master doc**

3. Navigate to the right hand side bar, where you want the new page to sit
4. Right hand click and select 'New file'
5. Give name to file ie. when-to-apply.md **make sure you put md on the end of the name if it is a markdown file**

Now you have created a page - you will need to fill in the top details:

**If you have created a page that will appear in one of the category pages ie. How to apply**

title: 	title will appear in the browser tab

heading: this is the h1 for the page - only needed if you want the h1 and the title to be different. If not, just add the title

description: must start with |- and then you can write the text here

related_content: list your related content links here, formatted as internal links

navigation:  this is to decide where the tile for this page will sit on the page - you will need to check what the other pages are listed as. They will be formatted like '30.20' - '30' will stand for the category page (in this case, how to apply) and the '20' will be the order it sits in on the tiles. These usually are assigned in increments of 5, just in case you later want to move on further up it can be easily moved by assigning an in between number.  

navigation_title: This is the title that will appear in the tiles

navigation_description: This is the description that will appear in the tiles

keywords: use Semrush to put keywords here, do a bulletpointed list using dashes like below:
  - adviser
  - advisor
  - ITT

Here is a blank version to take and fill in:
title:
heading:
description: 
related_content: 
navigation:  
navigation_title: 
navigation_description: 
keywords: 

## Saving a change
When you have made a change in Visual Studio Code and want to save your work.
1. Save the change by CTRL-S
2. This will cause a notification on the source control
3. You will need to type a name for this change in the 'message' box
4. Click the plus button that appears on the change - this will stage the change
5. Click 'sync changes'
6. Commit the changes - make sure you name each commit in the box above the blue box where it says commit. You should name each commit to the specific change being made. This makes it easier to review any changes in the pull request and is useful for auditing.
7. This will then open a pull request, you will need to fill in the details for this and click 'Create pull request' if you want to create one. But you may not want to create a pull request until you've made all of your changes so you don't have to publish the branch or create a pull request until you're ready
8. You can monitor pull requests and assign reviewers here https://github.com/DFE-Digital/get-into-teaching-app/pulls

## Preview a change
1. Go to the terminal tab on Visual Studio Code **or** Go the top bar of your laptop - click terminal - click 'new terminal'
2. A line of code will come up and you should type in **bin/dev**, this will start a series of code
3. When it has finished running, go into the ports tab and click the globe icon by 127.0.0.1:3000. This will open the browser
4. If you're not able to preview, try typing **bundle install** in the terminal followed by **yarn install** as this will update the libraries
5. When putting in a page to preview it, right click the page title on the left hand side bar in Visual Studio Code and copy path
6. Go to the url: http://127.0.0.1:3000 and insert a / on the end
7. The copied path will be something like this: /workspaces/get-into-teaching-app/app/views/content/a-day-in-the-life-of-a-teacher.md
8. Edit this path to only be the necessary page path: /a-day-in-the-life-of-a-teacher
The url is http://127.0.0.1:3000/a-day-in-the-life-of-a-teacher
9. You will need to CTL-Save a change in Visual Studio Code before viewing it in preview. You can just refresh the preview URL after you save a change to view it. But you don't need to commit the change to be able to view it.

## If you add something to the wrong branch

You can change the branch you've put changes under by going onto the pull request from the branch.
At the top there will be a line saying something like: 'you merged 1 commit into page-titles from Cookies-policy-update 3 hours ago'
If you want to move where this branch sits, click on the first title 'page titles' and it will produce a drop down
Select the correct place from the drop down.

## Redirect URLs
If you search in Visual Studio Code 'redirects' it will take you to a page 'redirects.yml'
**Currently you can only redirect internal links in this file. External redirects are handled in the routes file; you may need developer support to create or amend these.**
You will need to follow the pattern that the list of redirects uses in this file.
It will need to be in quotation marks. Then, you need to put the old url a colon and then the new url like this "/oldurl": "/newurl"
Example: "/train-to-be-a-teacher/teacher-training-personal-statement": "/how-to-apply-for-teacher-training/teacher-training-personal-statement"
Press enter to create an indention - 
Make sure the line is indented (the fine, white line that is currently running on the left hand side of all urls).
The easiest way to make sure you don't miss any pages to redirect is to do a search which will show you all the pages you need to include.

## Redirect blog tags
If you're deleting any blog posts as well as setting up redirects you'll also need to check the blog tags to see if there are any that need to be deleted too. **Blog tags live in the config file**.

## Finding links on the site
You can find everywhere a page is linked to by:
1. Go to [Github](https://github.com/DFE-Digital/get-into-teaching-app)
2. There is a search bar in the top right hand side
3. You should search a pages path here ie. /subjects/maths
4. The system will search for whereever this link is in the code across the website

## Resolving comments
People can add comments to pull requests in Github which makes it easier to see feedback and keep track of changes. You can also tag people and reply to their comments.

Once you've addressed a comment click on resolve. This hides it from the conversation making it easier to keep track of what's been updated.
