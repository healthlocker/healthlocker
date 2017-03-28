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

Images are similar to links but with `!` before the square brackets

```
![kitten on keyboard](http://www.rd.com/wp-content/uploads/sites/2/2016/04/01-cat-wants-to-tell-you-laptop.jpg)
![this will show if the image doesn't load](http://www.google.com/non-existent-image.jpg)
```
![kitten on keyboard](http://www.rd.com/wp-content/uploads/sites/2/2016/04/01-cat-wants-to-tell-you-laptop.jpg)
![this text will show if the image doesn't load - describe the image here](http://www.google.com/non-existent-image.jpg)

One possible issue with using markdown images is when the original image being
linked is very large, the image posted in stories will also be very large.

The image size can be changed by writing the image in an `html img` tag. The
`src` contains the link in quotes, `alt` contains the image description in
quotes, and `width` contains the size of the image in quotes.

The size of the image can be changed by changing the `width`.

`<img src="http://www.rd.com/wp-content/uploads/sites/2/2016/04/01-cat-wants-to-tell-you-laptop.jpg" alt="kitten on keyboard" width="300">`

<img src="http://www.rd.com/wp-content/uploads/sites/2/2016/04/01-cat-wants-to-tell-you-laptop.jpg" alt="kitten on keyboard" width="300">

You may not want to use this to make small images larger, as they may look
stretched or blurry, as below.

<img src="http://68.media.tumblr.com/avatar_995d57aef8ef_128.png" width="300">

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
