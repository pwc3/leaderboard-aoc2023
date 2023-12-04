# Advent of Code Leaderboard JSON to CSV Converter

## Setup

1. Get the JSON URL of your private leaderboard and write it to `.json-url`:
    1. Open your private leaderboard in your web browser.
    1. In the first paragraph, there should be a link to `use an [API]`. Click that link, which will cause another paragraph to appear.
    1. In the new paragraph, there should be a link there saying `You can also get the [JSON] for this private leaderboard`. Click that link.
    1. You should see the JSON representation of your leaderboard. Copy the page's URL and paste it to a file named `.json-url` in the root of the project.
1. Get your session cookie and write it to `.cookie`:
    1. In the web browser tab showing the JSON above, open the Web Inspector.
    1. In the Network tab, select the `GET` request that loaded the page.
    1. Under Headers > Request Headers, copy the value of the `Cookie` header. It should be a long hex-encoded string that starts with `session=`.
    1. Paste the value to a file named `.cookie` in the root of the project.

The latest version of Xcode and the Xcode Command Line Tools are needed to build and run this.

## Run

Downloading the JSON and converting to CSV are two separate steps.

### To download the JSON

```
swift run leaderboard fetch
```

This writes `leaderboard.json` to the root of the project.

### To convert the JSON to CSV

```
swift run leaderboard csv
```

This writes `leaderboard.csv` to the root of the project.


