---
title: "1570 days of HCNnews"
date: 2026-01-24T19:28:07-03:00
draft: false
tags: []
description: ""
featured_image: ""
gallery: []
---
For the first time ever since the HeriPoch (the HCNepoch), HCNews runs 100% by itself and can be considered 100% truly automated. It took 1570 days to get here. Let me try to explain how the project started, evolved, and where we are currently.

![HCGirls](HCgirls.png)

## First Steps

HCNews is a project inspired by the late Junior Muniz. He had a newspaper titled JRMUNEWS where he would by himself gather all these news, sources, things and compile them into a WhatsApp/Telegram/Instagram message. It was really incredible how much dense and how much information he was able to pack into it. I thought it was really funny and used to share it to my friends, so much that I got recognized by that. 

Junior passed away from cancer, but his nephew picked up the torch and now runs Vinimunews. The kid is like 15 years old, seems really fun. One time I had a chat with him and it's cool to see the legacy continue.

One Day my friends talked about having one version to themselves. Then HCNews started.

As it was just some scraping and very little logic, I opted to use bash scripting. It was (and still is) a dumb choice but we are too deep into it to change. For one script it's fine, but it got a lot more complex—it has a lot of modules and things I need to integrate and adapt. It's become a pain to write.

## First We Make It Exist, Then We Make It Good

I used to just run the script on my phone or computer and then copy/paste the output to WhatsApp. It got really cumbersome really fast. Everything ran consecutively. It was really slow.

Then, when I got the [TV-boxes](https://herijooj.github.io/posts/my-horrible-and-outdated-servers/), I changed to a telegram bot that sent it to me.

I had a number of beliefs about how HCNews should behave. Should it be a single daily message that is generated at a single predefined time? Then I had to generate it once and just serve the entire file when requested. Or should it be a new instance every time so you can get the most fresh news when you request it?

Today, each module has its own TTLs and when you request an HCNews it sends a moderately fresh version. It is fast. On a normal computer it runs at 1.6 seconds without anything cached, with everything fresh. It sends a message in 30 to 60 ms with cache.

## Web

I also now serve HCNews at a [website](https://herijooj.github.io/HCnews/). It uses GitHub Actions to run the script at pre-defined times. Different modules have different cache durations—some only run once a day.

It has some sections. When I stopped the telegram bot, I started to use it to relay to WhatsApp. (Foreshadowing)

## WhatsApp

From the start, the goal was to have an automated daily news scraper that sent messages on WhatsApp. The problem is that it does not have an official (free) API and I also do not have enough hardware to run an alternative solution. I had to get creative.

The TV-boxes run ARM7, the 32-bit version that nobody gives a fuck about anymore. I tried really hard to get something going on it (talking about a WhatsApp API). Docker? Are you crazy? It did go to 100% on all cores when the telegram bot got some traffic. It is impossible. But I came up with a solution.

Since now I got a brand new (for me) computer, I had a perfectly usable ThinkCentre M91p. I did some napkin math thinking about turning it into a 24/7 server. I currently use two ARM TV-boxes that together use maybe 15W at full power. Could I just use one x86 computer? Wrong. This thing uses 30W at idle—what both ARM boxes use together at full power. Energy in Brazil is not cheap. I can't get this going 24/7.

So one of the TV-boxes works as an orchestrator. It uses WOL to turn the computer on, then it wakes up the WhatsApp integration, generates the HCNews text, sends it, and powers it off. It runs from 07:00 to 23:00 at each complete hour. It checks if it already sent one for the day. It works really great. 

Thinking about it now, I could have come up with this solution a LONG time ago. 

## Future

I got HCNews figured out. It would be awesome to have a rewrite. There are still some things that could be much improved, but I think that now that I have this big blocker gone, we can do some better things.

I would love to have some alternative versions. I do focus on providing some regional things from my city and to my friends. Maybe I could have one for each city—shouldn't be much work, it would just have a bigger load and I'd have to find curated sources. But HCNews is modular enough that it would be pretty easy to do. It's also [open source](https://github.com/herijooj/HCnews), so anyone could easily pick it up and spin their own version.

Now im able to get some traffic going, advertising... Right now I have about 40 readers, but I think I can get a lot more with some Instagram ads and city-specific variants.

---

*1570 days from first commit to full automation. Not bad.*
