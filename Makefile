.PHONY: setup update serve clean

# Default category for fetching papers
QUERY ?= "cat:cs.CV+OR+cat:cs.AI+OR+cat:cs.CL+OR+cat:cs.LG+OR+cat:cs.NE+OR+cat:stat.ML"

setup:
	@echo "Setting up project..."
	uv venv
	if [ ! -f secret_key.txt ]; then \
		echo "Creating secret_key.txt..."; \
		openssl rand -base64 32 > secret_key.txt; \
	fi
	if [ ! -f as.db ]; then \
		echo "Initializing database..."; \
		sqlite3 as.db < schema.sql; \
	fi
	mkdir -p data/pdf data/txt static/thumbs tmp
	@echo "Setup complete. Run 'make update' to fetch papers or 'make serve' to start the server."

update:
	@echo "Running processing pipeline..."
	uv run fetch_papers.py --search-query $(QUERY)
	uv run download_pdfs.py
	uv run parse_pdf_to_text.py
	uv run thumb_pdf.py
	uv run analyze.py
	uv run buildsvm.py
	uv run make_cache.py
	@echo "Pipeline complete."

serve:
	@echo "Starting server..."
	uv run serve.py

clean:
	rm -rf data/ tmp/ static/thumbs/ *.p as.db secret_key.txt
