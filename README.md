PDF TOC to outlines
============================
append outlines from the TOC contents.

![from](https://github.com/user-attachments/assets/b80a5707-29dc-4c90-ba80-5af3b1df338f)

to


use cases
---------------
- append outlines to Google Document pdf

This is the my case.
Google Document exports PDF without outlines. (at least 2024/Nov.)

this program appends outlines from these PDF.


---


Requirements
-----------------------------------------
- nim (>= 2.0.2)
- libmupdf packages



Usage
-----------------------------------------

### Build in Debian Bookworm
- setup dependencies

```shell
$ sudo apt install libmupdf-dev libmujs-dev
$ sudo apt install libjpeg-dev libgumbo-dev libopenjp2-7-dev
$ sudo apt install libjbig2dec0-dev libfreetype-dev
```

- build

```shell
$ git clone https://github.com/kuri65536/pdf_toc_outlines
$ cd pdf_toc_ooutlines
$ nimble build
```


### Run

```shell
$ ./pdf_toc_outlines sample.pdf
```


### Options

option   | short | parameter | desc.
---------|----|--------------|-------
--pages  | -p | numbers [1]  | search links in specified pages
--alg    | -a | number [2]   | specify the match condition of links
--levels | -l | number [3]   | specify the leveling of links
--merge  | -m | number [4]   | specify the merge of links

[1]: #o-pages
[2]: #o-alg
[3]: #o-lvl
[4]: #o-mrg


#### option: --pages {#o-pages}
specify the numbers of pages to extract TOC.

```text
usage: --pages [numbers],[numbers],...
        numbers: number | range
        range:   [number]-[number] or [number]to[number]
        number:  [-0-9]+
```

example::
```text
    1. --pages 1-10 (default)
    2. --pages 1-3
    3. --pages 1,2,3
    4. --pages 1,4-10
    5. --pages 1,4,6,8-10
```


#### option: --alg {#o-alg}
specify the algolithm to determine TOC.

parameter | match condition
---|--------------------------------------------------
1  | match links contains `...` strings (default)
9  | convert all links to outlines in specified pages


#### option: --level {#o-lvl}
specify the algolithm for leveling the TOC links.

parameter | level condition
---|--------------------------------------------------
1  | x positions of link (default)
2  | heading numbers


#### option: --merge {#o-mrg}

parameter | merge condition
---|--------------------------------------------------
0  | no merge (default)
1  | merge the links in same y position


---



---


License
-----------------------------------------
MIT, see LICENSE


---


Information
-----------------------------------------

If you have attract or thank to this project,
Welcome to help or support with your donations.

