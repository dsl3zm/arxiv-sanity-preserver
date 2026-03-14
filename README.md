
# arxiv sanity preserver

**Update Nov 27, 2021**: you may wish to look at my from-scratch re-write of arxiv-sanity: [arxiv-sanity-lite](https://github.com/karpathy/arxiv-sanity-lite). It is a smaller version of arxiv-sanity that focuses on the core value proposition, is significantly less likely to ever go down, scales better, and has a few additional goodies such as multiple possible tags per account, regular emails of new papers of interest, etc. It is also running live on [arxiv-sanity-lite.com](https://arxiv-sanity-lite.com).

This project is a web interface that attempts to tame the overwhelming flood of papers on Arxiv. It allows researchers to keep track of recent papers, search for papers, sort papers by similarity to any paper, see recent popular papers, to add papers to a personal library, and to get personalized recommendations of (new or old) Arxiv papers. This code is currently running live at [www.arxiv-sanity.com/](http://www.arxiv-sanity.com/), where it's serving 25,000+ Arxiv papers from Machine Learning (cs.[CV|AI|CL|LG|NE]/stat.ML) over the last ~3 years. With this code base you could replicate the website to any of your favorite subsets of Arxiv by simply changing the categories in `fetch_papers.py`.

![user interface](https://raw.github.com/karpathy/arxiv-sanity-preserver/master/ui.jpeg)

### Dependencies & Setup

This project now uses [uv](https://github.com/astral-sh/uv) for fast, reliable Python package management.

**External dependencies**: You will also need [ImageMagick](http://www.imagemagick.org/script/index.php) and [pdftotext](https://poppler.freedesktop.org/), which you can install on Ubuntu as `sudo apt-get install imagemagick poppler-utils` or on macOS with `brew install imagemagick poppler`.

To get started:

1. **Install uv** (if you haven't already):
   ```bash
   curl -LsSf https://astral.sh/uv/install.sh | sh
   ```

2. **Setup the project**:
   This will create a virtual environment, initialize the database, and generate a secret key.
   ```bash
   make setup
   ```

### Processing pipeline

To fetch papers and build the search index:

```bash
make update
```

By default, this fetches papers from ML-related categories. You can customize the query:
```bash
make update QUERY="cat:cs.AI"
```

### Running the server

To start the web interface:

```bash
make serve
```

Visit `localhost:5000` to browse papers.

### Code layout

There are two large parts of the code:

**Indexing code**. Uses Arxiv API to download the most recent papers in any categories you like, and then downloads all papers, extracts all text, creates tfidf vectors based on the content of each paper. This code is therefore concerned with the backend scraping and computation: building up a database of arxiv papers, calculating content vectors, creating thumbnails, computing SVMs for people, etc.

**User interface**. Then there is a web server (based on Flask/Tornado/sqlite) that allows searching through the database and filtering papers by similarity, etc.
