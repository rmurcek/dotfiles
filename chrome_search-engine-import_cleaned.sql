begin transaction;
insert into keywords (short_name, keyword, url, favicon_url) values ('Google Maps', 'map', 'https://www.google.com/maps/search/{searchTerms}?hl=en&source=opensearch', 'https://www.google.com/images/branding/product/ico/maps15_bnuw3a_32dp.ico');
insert into keywords (short_name, keyword, url, favicon_url) values ('Wikipedia (en)', 'wik', 'http://en.wikipedia.org/wiki/Special:Search?search={searchTerms}', 'https://en.wikipedia.org/static/favicon/wikipedia.ico');
insert into keywords (short_name, keyword, url, favicon_url) values ('linkedin', 'li', 'https://www.linkedin.com/search/results/all/?keywords={searchTerms}', 'https://static.licdn.com/aero-v1/sc/h/3loy7tajf3n0cho89wgg0fjre');
insert into keywords (short_name, keyword, url, favicon_url) values ('Stack Overflow', 'stackoverflow.com', 'https://stackoverflow.com/search?q={searchTerms}', 'https://cdn.sstatic.net/Sites/stackoverflow/Img/favicon.ico?v=ec617d715196');
insert into keywords (short_name, keyword, url, favicon_url) values ('Metropolis Jira', 'jira', 'https://metropolisio.atlassian.net/secure/QuickSearch.jspa?searchString={searchTerms}', 'https://metropolisio.atlassian.net/images/16jira.png');
insert into keywords (short_name, keyword, url, favicon_url) values ('Confluence', 'conf', 'https://metropolisio.atlassian.net/wiki/search?text={searchTerms}', 'https://metropolisio.atlassian.net/wiki/s/-1049812723/6452/18bfb7dee018214f7a2514b436b7843a9c0b626e/8/_/favicon-update.ico');
insert into keywords (short_name, keyword, url, favicon_url) values ('Github PRs', 'pr', 'https://github.com/metropolis-io/site/pull/{searchTerms}', 'https://github.githubassets.com/favicons/favicon.svg');
insert into keywords (short_name, keyword, url, favicon_url) values ('Metropolis Ticket', 'tik', 'https://metropolisio.atlassian.net/browse/{searchTerms}', 'https://metropolisio.atlassian.net/s/xtxyma/b/6/d010741f533b93cde3e20c1ba159b410/_/jira-favicon-scaled.png');
insert into keywords (short_name, keyword, url, favicon_url) values ('Google Drive', 'dr', 'https://drive.google.com/drive/search?q={searchTerms}', 'https://ssl.gstatic.com/docs/doclist/images/drive_2022q3_32dp.png');
insert into keywords (short_name, keyword, url, favicon_url) values ('Greenhouse', 'gh', 'https://app3.greenhouse.io/people?job_status=all&search_terms={searchTerms}&sort_by=last_activity&sort_order=desc&type=all', 'https://app3.greenhouse.io/favicon.ico');
insert into keywords (short_name, keyword, url, favicon_url) values ('gmail', 'mail', 'https://mail.google.com/mail/u/0/#search/{searchTerms}', '');
end transaction;
