PDF TOC to outlines
============================
append outlines (bookmarks) from the TOC contents.

![from](https://github.com/user-attachments/assets/b80a5707-29dc-4c90-ba80-5af3b1df338f)

to

![to](https://github.com/user-attachments/assets/ac558ace-dea8-43b8-a707-7ad3e07ce0fc)


use cases
---------------
### append outlines to Google Document PDF

This is the my case.
Google Document exports PDF without outlines. (at least 2024/Nov.)

this program appends outlines from these PDF.


---


Requirements
-----------------------------------------
- nim (>= 2.0.2)
- libmupdf packages


---


Usage
-----------------------------------------

### Build in Debian Bookworm
- setup dependencies

```shell
$ sudo apt install libmupdf-dev libmujs-dev
$ sudo apt install libjpeg-dev libgumbo-dev libopenjp2-7-dev
$ sudo apt install libjbig2dec0-dev libfreetype-dev
```

- install nim >= 2.0.2
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
--output | -o | file-name    | specify the output file of PDF
--pages  | -p | numbers      | search links in specified pages [1]
--alg    | -a | number       | specify the match condition of links [2]
--levels | -l | number       | specify the leveling of links [3]
--merge  | -m | number       | specify the merge of links [4]
--subst  | -s | number       | specify the substitutes of links [5]

[1]: #option---pages
[2]: #option---alg
[3]: #option---level
[4]: #option---merge
[5]: #option---subst


#### option: --pages
specify the numbers of pages to extract TOC.

```text
usage: --pages [numbers],[numbers],...
        numbers: number | range
        number:  [-0-9]+
        range:   [number]-[number] or [number]to[number]
```

example::
```text
    1. --pages 1-10 (default)
    2. --pages 1-3
    3. --pages 1,2,3
    4. --pages 1,4-10
    5. --pages 1,4,6,8-10
```

#### option: --alg
specify the algolithm to determine TOC.

parameter | match condition
---|--------------------------------------------------
1  | match links contains `...` strings [under construction]
9  | convert all links to outlines in specified pages (default)


#### option: --level
specify the algolithm for leveling the TOC links.

parameter | level condition
---|--------------------------------------------------
1  | x positions of link (default)
2  | heading numbers [under construction]


#### option: --merge

parameter | merge condition
---|--------------------------------------------------
0  | no merge (default)
1  | merge the links in same y position [under construction]


#### option: --subst

parameter | merge condition
---|--------------------------------------------------
0  | split by '.' and take the 1st string. (default)
(1) | regex by the trainling string and take the 1st part of matches [under construction]


---


Under construction
-----------------------------------------

[under construction]: #under-construction

- pages option: parse pages
- alg   option: convert links only to outlines by specific rules.
- level option: heading numbers
- merge option: merge links in the same y position
- subst option: by regex



---


License
-----------------------------------------
MIT, see LICENSE


---


Information
-----------------------------------------

If you have attract or thank to this project,
Welcome to help or support with your donations.

- Bitcoin **| 19AyoXxhm8nzgcxgbiXNPkiqNASfc999gJ |**
- Ether **| 0x3a822c36cd5184f9ff162c7a55709f3d6d861608 |**
- or librapay

