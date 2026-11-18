# Publication feeds

Habr [merged its publication feeds](https://habr.com/ru/companies/habr/articles/1105376/) in November 2026. The web client (2.361.2) reads lists from `GET /kek/v2/articles/`. A list request without a source selector returns HTTP 400.

| Web page | Query parameters |
| --- | --- |
| My Feed | `queryType=feed`, rating threshold or `score=all`, difficulty or `complexity=all` |
| All articles, newest | `queryType=articles&sort=rating`, optional `score` |
| All articles, best | `queryType=articles&sort=date`, `period` |
| Thematic flow | `queryType=flows_new&sort=all`, `flow` alias, optional `score` or `period` |
| Hub | `queryType=hubs&sort=all`, `hub` alias, optional `score` or `period` |

The web client includes `page` (starting at 1), `perPage` (20), `fl` and `hl`. Public lists omit the difficulty for the unrestricted selection. Difficulty values in requests are `easy`, `medium` and `hard`. The response uses `low`, `medium` and `high`.

A format selection is an indexed array, for example `formats[0]=post&formats[1]=case`. Supported values are `common` (no format), `post`, `tutorial`, `analytics`, `reportage`, `digest`, `interview`, `faq`, `opinion`, `review`, `retrospective`, `roadmap` and `case`. Public lists omit this array when all formats are selected. Applying personal feed filters can send the full selection.

The response contains `publicationIds`, `publicationRefs` and `pagesCount`. A short publication can have `publicationType=article`, `postType=article` and `format=post`. Its detail URL is an article URL.
