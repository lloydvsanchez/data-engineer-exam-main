## Overview

This technical exam will test your ability to work with web APIs, process and
transform the resulting data, then load them into another tool for analysis.

## What you need

You'll need the following to complete this exam:

* Knowledge of any of the following scripting language: Python, JS, Ruby, PHP
* A working system that can execute the language interpreter
* An Internet connection to query the live APIs
* Knowledge on how to use web APIs
* API keys*

*When you are ready to code, please let us know, so we can share with you the keys you can use to query the APIs.

## Steps

#### Part 1

Write a script, that will be invoked in the Makefile target `extract`, that performs the following:

Perform a query of the Google Places API, to retrieve a list of places of type _restaurant_, within a 2 KM radius of our office in Cebu ([maps link](https://goo.gl/maps/kUSjczZAt4wyNCxx7)).

Save the resulting data to a JSON file under the `var/` folder, with name `synacy_nearby.json`, using the following schema:

```
[ { place_id: '…',
    name: '….',
    location: 'lon,lat',
    global_pluscode: '…',
    vicinity: '….'
  },
  { place_id: '…',
    name: '….',
    location: 'lon,lat',
    global_pluscode: '…',
    vicinity: '….'
  }
  ...
]
```

#### Part 2

Write a script, that will be invoked in the Makefile target `transform`, that performs the following:

Parse the `synacy_nearby.json` file, and perform the following processing:

1. Store each place entity in its own line, grouped by plus code, in a new file in JSON format.
2. The entities should be stored in files that corresponds to the mapping of their `global_pluscode`, as follows:

`<first four chars>/<next 2 chars>/<next 2 chars>.json`

Example, for `global_pluscode`: `7Q258WJ3+G3`, JSON file should be: `7Q25/8W/J3.json`

Example on how the `json` file will look like:

```
{ place_id: '…', name: '….', location: 'lon,lat', global_pluscode: '…', vicinity: '….' }
{ place_id: '…', name: '….', location: 'lon,lat', global_pluscode: '…', vicinity: '….' }
```

#### Part 3

Write a script, that will be invoked in the Makefile target `load`, that performs the following:

Upload the resulting json files from part 2 to the S3 bucket, `synacy-recruitment-applicant-workspace`, inside your designated working path (i.e. `data-engineer-exam/<your name>`). Make sure to maintain the file hierarchy as generated in part 2.

Add a logic that only updates the file if it has last updated more than 4 hours ago.

## Submit your answers

Your submission will compose of the uploaded JSON files in the S3 bucket, and your code in a new _private_ Github repo in your own Github account.

Please grant us access to this repo, so we can review your work.

## Tips

We offer the following tips:

* We often execute our data scripts in a server-less environment. It is recommended, if you can use only the standard/built-in libraries of the programming language. You may use official/3rd party libraries, but you'll have to explain how to ensure dependencies are met in the server-less runtime.

* We highly rate code quality (well-constructed, legible, non-cryptic), together with an effective solution. Code written well AND works, is always better than code that just works.

* Don't be shy to ask questions and clarifications. Though please, not the obvious ones which you can easily _google_ around.

* Be as elaborate and elegant as you like. Same as code quality, if you want to showcase certain patterns that you really like, please include it, and let us know about it. Always highly appreciated if we get to learn something new in the process.

* Speaking of patterns, of course, it's normal these days to _google_ code patterns, and copy existing solutions found online (e.g. StackOverflow). We ourselves sometimes do this, to get inspiration on how to achieve something. If you ever do this, please make sure you understand what's going on, since you'll need to defend your solution during the interview. And one thing we hate a lot is clueless and mindless hacking pieces together found on the Internet. It's just a serious offense, that's hard to ignore.
