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
    * [Prevent Indexing](#prevent-indexing)
    * [Adding a Document or Image](#adding-a-document-or-image)
    * [Calls to Action](#calls-to-action)
    * [Adviser (CTA) component](#adviser-cta-component)
    * [Routes (CTA) component](#routes-cta-component)
    * [Main Content](#main-content)
    * [Sidebar](#sidebar)
    * [Accessibility](#accessibility)
    * [iframe](#iframe)
    * [Inset text](#inset-text)
     * [Creating a partial](#creating-a-partial)
    * [Details expander for non-UK content](#details-expander-for-non-uk-content)
    * [YouTube Video](#youtube-video)
    * [Hero](#hero)
    * [Values](#values)
4. [Search engine optimisation](#search-engine-optimisation)
5. [Creating a subject page](#creating-a-subject-page)
6. [Creating an inspirational page](#creating-an-inspirational-page)
7. [Navigation](#navigation)
    * [Main Navigation](#main-navigation)
    * [Category Pages](#category-pages)
8. [Build errors](#build-errors)
9. [Internship providers](#internship-providers)
10. [Creating a new page](#creating-a-new-page)
11. [Preview a change](#preview-a-change)
12. [Saving a change](saving-a-change)
13. [If you add something to the wrong branch](wrong-branch)
14. [Redirect URLs](redirect-urls)
15. [Finding links on the site](links-site)
16. [Resolving merge conflicts](merge-conflicts)


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

The majority of web pages on the site are within the [/app/views/content](https://github.com/DFE-Digital/get-into-teaching-app/tree/master/app/views/content) directory; this reflects the top-level pages of the website (including the home page). If, for example, you wanted to edit [the 'Teacher pay' page](https://getintoteaching.education.gov.uk/life-as-a-teacher/pay-and-benefits/teacher-pay) content you would edit the file [/app/views/content/life-as-a-teacher/pay-and-benefits/teacher-pay.md](https://github.com/DFE-Digital/get-into-teaching-app/blob/master/app/views/content/life-as-a-teacher/pay-and-benefits/teacher-pay.md). The structure here mimics the URL of the pages (the home page is a special case):

| URL                                     | Content File                                                 |
| ---------------------------------       | ---------------------------------------------------------    |
| /                                       | /app/views/content/home.md                                   |
| /funding-and-support                    | /app/views/content/funding-and-support.md                  |
| /life-as-a-teacher/pay-and-benefits/teacher-pay | /app/views/content/life-as-a-teacher/pay-and-benefits/teacher-pay.md |

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

Breadcrumbs are included by default on most layouts with the exception of registration layouts. You can chose to optionally disable breadcrumbs by setting the following in the front matter:

```yaml
---
breadcrumbs: false
---
```

### Links

Whilst links are just standard Markdown its worth noting that if you are linking internally to another web page on the GiT website you should only include the path, for example `[find an event](/events)` instead of `[find an event](https://getintoteaching.education.gov.uk/events)`. We do this so that the links work on all our test environments as well as production.


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

The images used in the hero now pull their alt text from a central store. This allows us to set it once and include it wherever the image is used. The data is stored in `config/images.yml` and the format is as follows:

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
### Creating a partial 

If the content you are creating will be used elsewhere on the site in the exact same format, it may be a good idea to create a partial. This is a snippet of code that you will be able to render in one line. This saves you have having to write the same things again and again. It also means maintenance of the site is easier as any changes you make can be done in one central place rather having to keep track of what information is on what pages.

To create a partial go to the /app/views/content/shared folder then either select an appropriate file or create your own folder. Then create a file. In the file place the HTML code that you would like to replicate on multiple pages. 

```yaml
<div class="check-qualifications">
  <h3>Check your qualifications</h3>
  <p>To train to teach in England, you'll need:</p>
  <ul>
    <li>GCSEs at grade 4 (C) or above in English and maths (and science if you want to teach primary)</li>
    <li>a bachelor's degree in any subject</li>
  </ul>
  <p>Having relevant A levels can show your subject knowledge, if you do not have a degree in your chosen subject.</p>
</div>

```

Then, when you are working in another HTML file and want to render your code all you have to do is reference the code you created as follows:

```yaml
 <%= render 'content/shared/qualifications-training/check_qualifications' %> 
```
If you need a specific change across each version of your code such as the subject, it is possible to create a variable. All you have to do is reference something in the frontmatter. In the following frontmatter the subject is chemistry. 

```yaml
title: Become a chemistry teacher
subject: chemistry
title_paragraph: |-
  <p>
  As a chemistry teacher, you'll spark curiosity and challenge young minds to explore the fundamental principles that govern our world. You'll inspire students to question, experiment, and discover, fuelling their passion for science.</p>
  <p>
  Tax-free bursaries of $bursaries_postgraduate_chemistry$ or scholarships of $scholarships_chemistry$ are available for eligible trainee chemistry teachers.</p>
description: |-
    Find out how to become a chemistry teacher, including what you'll teach and what funding is available to help you train.
layout: "layouts/minimal"
colour: pastel yellow-yellow
image: "static/images/content/hero-images/chemistry.jpg"
keywords:
  - chemistry
  - teaching chemistry
  - teacher training

content:
  - "content/shared/subject-pages/header"
  - "content/life-as-a-teacher/explore-subjects/chemistry/article"
```

To create a variable that references the frontmatter simply copy the format below. This will look at the frontmatter, then whatever you reference in the square brackets. In this case, it will look for subject and will render chemistry. This can be changed for anything as long as it is referenced in the frontmatter. 
```yaml
<%= @front_matter["subject"] %> 
```
This means that you can use the following code over many pages so that each page has its own unique subject rendered.  
```yaml
<div class="check-qualifications">
  <h3>Check your qualifications</h3>
  <p>To train to teach <%= @front_matter["subject"] %> in England, you'll need:</p>
  <ul>
    <li>GCSEs at grade 4 (C) or above in English and maths (and science if you want to teach primary)</li>
    <li>a bachelor's degree in any subject</li>
  </ul>
  <p>Having relevant A levels can show your subject knowledge, if you do not have a degree in <%= @front_matter["subject"] %>.</p>
</div>

```





### Adviser (CTA) component

You can use the Adviser (Call to Action) component to create a call to action to invite users to sign up for the Get an Adviser service. You can use the component directly in markdown files, or in ERB-HTMl partials. It takes the following parameters and all are optional - if not specified a default value will be used:

* title
* text
* image
* link_text
* link_target
* classes
* border

```yaml
---
cta_adviser:
  adviser1:
    title: "Optional title"
    text: "Optional text"
    image: "/optional/path/to/image"
    link_text: "Optional link text"
    link_target: "/optional/path"
    classes: ["class1", "class2", "class3"]
    border: true
---

# My page

$adviser1$
```
Alternatively, if you need to insert an adviser component in an erb file, you can call it like this:

```yaml
<%= render CallsToAction::AdviserComponent.new(
  title: "Optional title",
  text: "Optional text",
  image: "/optional/path/to/image",
  link_text: "Optional link text",
  link_target: "/optional/path",
  classes: ["class1", "class2", "class3"],
  border: true
)%>
```

### Routes (CTA) component

You can use the Routes (Call to Action) component to create a call to action to invite users to find their route into teaching. You can use the component directly in markdown files, or in ERB-HTMl partials. It takes the following parameters and all are optional - if not specified a default value will be used:

* title
* text
* image
* link_text
* link_target
* classes
* border

```yaml
---
cta_routes:
  routes:
    title: "Optional title"
    text: "Optional text"
    image: "static/images/routes.png"
    link_text: "Optional link text"
    link_target: "/optional/path"
    classes: ["class1", "class2", "class3"]
    border: true
---

# My page

$adviser$
```
Alternatively, if you need to insert an routes component in an erb file, you can call it like this:

```yaml
<%= render CallsToAction::RoutesComponent.new(
  title: "Optional title",
  text: "Optional text",
  image: "static/images/routes.png",
  link_text: "Optional link text",
  link_target: "/optional/path",
  classes: ["class1", "class2", "class3"],
  border: true
)%>
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

You can use the Values system to maintain key values (e.g. salaries, bursaries, fees etc) in a single file, and then use these values throughout the site's content. Set up a list of values in one or more YML files stored in the `config/values/` folder (or sub-folder), for example `config/values/salaries.yml`:

```yaml
salaries:
  example:
    max: £40,000

```

These values can then be used in markdown files by referencing the value as `$value_name$`, e.g. `$salaries_example_max$`. Note that structured composite keys will be flattened to a single key.

An example markdown implementation might be:

```markdown
# Starting salary

All qualified teachers will have a starting salary of at least $salaries_starting_min$ (or higher in London).
```

Values can be used in ERB templates using `<%= value :value_name %>` (or as a shorthand, `<%= v :value_name %>`). 

An example ERB implementation might be:

```html
<h1>Starting salary</h1>
<p>
  All qualified teachers will have a starting salary of at least <%= v :salaries_starting_min %> (or higher in London).	
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
        sub_head: "Maths - starting salary: %{salaries_starting_min}"
        funding: "Bursaries of %{bursaries_postgraduate_maths} are available."
```

A list of the current values available on the site can be viewed at the `/values` endpoint.

Values should be named using only _lowercase_ characters `a` to `z`, the numbers `0` to `9`, and the underscore `_` character. Unsupported characters such as the hyphen `-` are converted into underscores.

## Search engine optimisation

Whenever we add a new page to the GIT website, we need to make sure it’s optimised for search engines, this is known as search engine optimisation (SEO). This means that the page has the best chance possible of ranking in a high position in the search results when people type a related query in.

In Autumn 2024, an SEO consultant provided us with guidelines for how to improve the SEO on the website.

When uploading a new webpage, or reviewing an existing one, these are the main things you’ll need to do to make sure the page is optimised.

### Find out what people are searching for

If you’re adding new content to the GIT website or reviewing existing content, any changes should be based on user needs. You can make sure the content is optimised for the search engines by looking at what users are searching for in Search Console. If you're new to the team, speak to the Delivery Manager about getting set up on Search Console.

For example, if you were to create a page around being a primary school teacher some terms you might want to include could be:
- ‘skills to be a primary teacher’
- ‘primary education courses’
- ‘primary teaching with QTS’

### Consider the context

It’s important to consider the context of search terms. For example, users might be searching for ‘teachers pension increase’ but that’s not something we would cover on the GIT website. A term like this is more likely to be from users who are already teachers and their query would be better answered by the teacher pensions website.

Some terms may:
- not be teaching specific (‘uk qualifications’)
- be too broad (‘high school teacher’)
- be addressed by other services, such as Teaching Vacancies (‘english teacher jobs’)

You can find out more about optimising content for what users are searching for by viewing the following documents from the Autumn 2024 SEO review:
- keyword map
- content optimisation guidance
These are stored in the Get Into Teaching Ebsite Project folder in Teacher Services SharePoint.

### Internal links

Internal linking is when a page on a website links through to another page on the same website. This is important for SEO as it helps the search engines understand which pages relate to each other. It also helps users navigate the site.

When creating or updating a page, make sure:
- all pages have more than one internal link
- use the keyword that you want the page to rank for as the anchor text, e.g. use ‘qualified teacher status (QTS)’ as the link rather than ‘you’ll be qualified as a teacher’
- internal links link to the canonical version of pages (these are the pages we want to rank) so they do not have to go through redirects
- you link to any new pages from existing, relevant pages

### URL structure

The URL on a page helps the search engines understand what a page is about.

When creating a page or updating a URL, make sure:
- the URL includes a target keyword, where it is sensible to do so e.g. `/train-to-be-a-teacher/teacher-degree-apprenticeships`, rather than `/train-to-be-a-teacher/tda`
- URLs are short and make sense when read by humans

### Headers

Where possible, include keywords in the content headers. Headers should follow a clear structure e.g. H1, H2, and H3. This is important for accessibility, as well as SEO.

### Acronyms

Users may not know certain acronyms well enough to include them in their search terms. Always spell out words in full first, and more than once, if they are the keywords for a particular page.

In some cases, users may be more familiar with the acronym than the full word. For example:
- ‘QTS’ gets more searches than ‘qualified teacher status’
- ‘teacher degree apprenticeship’ gets more searches than ‘TDA’

You can find out more about how we use acronyms in the:
- [DfE content style guide](https://design.education.gov.uk/design-system/style-guide)
- [Government Digital Services (GDS) style guide](https://www.gov.uk/guidance/style-guide/a-to-z)

### Front matter

In our frontmatter we can populate several values that are used for SEO:

```yaml
title: "A title for the page"
description: "A description of the page"
image: "path/to/image.png"
date: "2021-11-01"
```

Ideally all titles should be unique, descriptions should be no more than 160 characters and the image will most likely be visible when sharing web page links via social media platforms. If a date is specified it will be used as the last modified date for the sitemap entry.

### Monitoring SEO impact

You can use Search Console to get an idea of how a search term or page is performing. 

1. Click on the date filter in the 'Search Results' section.
2. Select 'Compare'.
3. Compare a date range before your changes with a similar period after the changes.
4. Check for improvements in clicks, impressions, and rankings.


You can also check how specific pages are performing:

1. Go to 'Search Results' and add filter, then select ‘Page’.
2. Enter the URL for the page you want to check.
3. Review metrics such as impressions, clicks, and position for those pages.
4. You can change the dates for individual pages too, so you can compare stats before and after any changes.

To see how keyword targeting is performing: 

1. Click 'Search Results'.
2. Click 'Add filter' and select 'Query'.
3. Enter the query or part of the query e.g. ‘SEND’ will bring any query up with ‘SEND’ in it such as ‘SEND training’.
4. Check if optimised keywords:
   - have higher impressions and clicks
   - have improved their average position in search results
5. You can also see how individual pages are doing for specific keywords by filtering by query and page.

It can take weeks or even months for changes to have an impact, so check the above regularly.



## Creating a subject page

Create a subject folder under ‘content/life as a teacher’

From a previous published subject page copy the 2 files:

-	_article.html/erb
-	_header.html.erb

Also copy and paste a previous subject ‘.md’ file and rename it with the subject (e.g english.md)

#### File changes:

_header.html.erb – no changes needed

The main content of subject pages should be written in HTML format using the following template as a guide:

_article.html/erb 

Update the markdown file to edit the hero banner image, hero banner text (title and title_paragraph) and the page’s card component. You will also need to ensure the links to the html erb files are updated

Subject.md

```yaml
---
title: Become a subject teacher
title_paragraph: |-
  <p>Tax-free bursaries of $bursaries_postgraduate_subject$ or scholarships of $scholarships_subject $ are available for eligible trainee subject teachers.</p>
description: |-
   Find out how to become a subject teacher including what you'll be teaching and what funding is available to help you train.
backlink: "../../"
subcategory: What to teach
navigation: 5.43
navigation_title: Subject name
navigation_description: Subject content
layout: "layouts/minimal"
colour: pastel yellow-yellow
image: "static/images/content/homepage/directory4.jpg"
keywords:
  - keyword 1
  - keyword 2
  - keyword 3
 
content:
  - "content/life-as-a-teacher/subject/header"
  - "content/life-as-a-teacher/subject/article"
---
```

## Creating an inspiration page

Create a folder under ‘content/life-as-a-teacher/sub-category’

From a previous published page copy the files:

_article.html/erb
_header.html.erb

Also copy and paste a previous ‘.md’ file and rename it with the title (e.g abigails-career-progression-story.md). This should live inside the subcategory folder, but not within the same folder as the article and header files.

#### File changes:

_header.html.erb – no changes needed

The main content of page should be written in HTML format using the following template as a guide:

_article.html/erb 

Update the markdown file to edit the hero banner image, hero banner text (title and title_paragraph) and the page’s card component. Hero images on inspirational pages always use the grey-pink colours as shown below. You will also need to ensure the links to the html erb files are updated:

```yaml
---
title: Abigail's favourite things about teaching
title_paragraph: |-
  <p>Abigail is a maths teacher from Wigan.</p>
description: |-
  Hear what Abigail enjoys most about teaching, and the impact she has through her job.
layout: "layouts/minimal" 
colour: grey-pink 
image: "static/images/content/case-studies/abigail.jpg" 
keywords:
  - teaching
  - maths
  - science
content: 
  - "content/life-as-a-teacher/pay-and-benefits/abigails-favourite-things-about-teaching/header" 
  - "content/life-as-a-teacher/pay-and-benefits/abigails-favourite-things-about-teaching/article"
  - "content/life-as-a-teacher/how-to-become-a-teacher-cta"
---
```

To add the pages card component go to the relevant category page eg. content/life-as-a-teacher/pay-and-benefits/_what-teachers-have-to-say.html.erb

And copy and paste an exiting card such as:

```yaml
<ul>
  <%= render Content::InspirationCardComponent.new(heading_tag: "h3", card:
    OpenStruct.new(
      title: "Abigail's favourite things about teaching",
      description: "Hear what Abigail enjoys most about teaching, and the impact she has through her job.   ",
      path: "/life-as-a-teacher/pay-and-benefits/abigails-favourite-things-about-teaching",
      image: "static/images/content/case-studies/abigail.jpg"
    )) %>
</ul>
```

Update the title, description and image as required.

## Add a quote with image component

Add this code to a html file:

```html
<div class="row">
  <div class="col-space-l col-space-l-top">
    <%= render Content::QuoteWithImageComponent.new(
      title: "Example title to go here",
      text: "<h4>Heading if neededd</h4><p>Example information or quote</p><a href='#'>Link text/a>",
      quotes: false,
      background_color: "blue",
      heading_color: "pink",
      image_path: "static/images/content/hero-images/0034.jpg"
    ) %>
  </div>
</div>
```
You can edit the colours used such as "yellow", "pink", "green", "blue" and "purple". You can also specify whether you want the quote marks to appear by using true or false in the quotes parameter. For shorter quotes its better to use an image with a height cropped to around 300 pixels.

When using in a markdown file, copy the above code into a new html file and link to the file in the markdown code, in the same way you would when creating a subject page:

```html
content: 
  - "content/life-as-a-teacher/pay-and-benefits/quote" 
```

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

## Finding links on the site
You can find everywhere a page is linked to by:
1. Go to [Github](https://github.com/DFE-Digital/get-into-teaching-app)
2. There is a search bar in the top right hand side
3. You should search a pages path here ie. /subjects/maths
4. The system will search for whereever this link is in the code across the website

## Resolving comments
People can add comments to pull requests in Github which makes it easier to see feedback and keep track of changes. You can also tag people and reply to their comments.

Once you've addressed a comment click on resolve. This hides it from the conversation making it easier to keep track of what's been updated.

## Merge Conflicts
Merge conflicts arise when two different branches alter the same content and both compete to have their changes merged into a common branch (usually `master`). Merge conflicts can be reduced by regularly keeping your branch synchronised with the `master` branch. Also try to co-ordinate with colleagues to ensure that you are not working on the same files/content as they are.

Simple merge conflicts can be resolved in the Github text editor by preserving the content which should persist and manually deleting the content which should lapse. For full steps please see:

* [Resolving a merge conflict on GitHub](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/addressing-merge-conflicts/resolving-a-merge-conflict-on-github)

Complex merge conflicts will need to be resolved via the git commandline and will require developer assistance.
