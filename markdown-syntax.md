# Guide to writing markdown

This guide will follow the pattern of showing how to write markdown followed by
how it will display.

#### Headers

You can display different sized headers depending on how many `#` you put
before the text. Be sure to include a space between the `#` and the text.

```
# Header 1
## Header 2
### Header 3
#### Header 4
##### Header 5
###### Header 6
```

# Header 1
## Header 2
### Header 3
#### Header 4
##### Header 5
###### Header 6

#### Links
You can have a link with text to display by using:

```
[This will be what's displayed](https://www.healthlocker.uk/)
```
[This will be what's displayed](https://www.healthlocker.uk/)

#### Images

Instead of using markdown images for this, we will be using `html` with inline
styles.

This is so that we can get a centered, round image without having to grab all
the content, manipulate, then put it back together.

The images will now be added as below.

```html
<div class="w4 h4 bg-center cover br-100 center"
  style="background-image:url(http://www.rd.com/wp-content/uploads/sites/2/2016/04/01-cat-wants-to-tell-you-laptop.jpg)">
</div>
```

To change the image, the only part that needs to change is the link in the `()`.

```html
<div class="w4 h4 bg-center cover br-100 center"
  style="background-image:url(http://change_this)">
</div>
```

#### Paragraphs

Paragraphs are separated by hitting enter twice (i.e. having a blank line
between paragraphs)

```
This is a paragraph.

Because it is separated from this with two newlines.

This will be the same paragraph as the next line...
Because it is only separated by a single newline.
```
This is a paragraph.

Because it is separated from this with two newlines.

This will be the same paragraph as the next line...
Because it is only separated by a single newline.

#### Bold & italics

Bold:
```
**This will be bold**
```
**This will be bold**

Italics:
```
*This will be italicised*
```
*This will be italicised*

#### Lists
You can have numbered lists or bullet point lists.

Bullet point lists can use `*` or `-`. You can have nested lists with either b

```
* This is a bullet point
- And so is this
```
* This is a bullet point
- And so is this

```
1. Item 1
2. Item 2
```
1. Item 1
2. Item 2

A more detailed guide to markdown can be found
[here](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)
if there are other things which you would like to include in stories or tips.
This includes nested lists, tables and more.
