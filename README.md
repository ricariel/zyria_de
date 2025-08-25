# zyria.de Website

This repository contains the source code for the [zyria.de](https://zyria.de) website. It serves as a personal blog and knowledge base, primarily focusing on topics related to homelabs, networking, and solar energy.

## Technologies Used

* **Hugo**: A fast and flexible static site generator written in Go.
* **Node.js / npm**: Used for managing front-end dependencies and build tooling (e.g., PostCSS for CSS processing).

## Getting Started

To get the website running locally for development, follow these steps:

### Prerequisites

Ensure you have the following installed on your system:

* **Hugo (extended version)**: Follow the official Hugo installation guide: [https://gohugo.io/getting-started/installing/](https://gohugo.io/getting-started/installing/)
* **Node.js and npm**: Download from [https://nodejs.org/](https://nodejs.org/)

### Local Development Setup

1. **Clone the repository:**

   ```bash
   git clone https://github.com/your-username/zyria_de.git
   cd zyria_de
   ```

   *(Note: I'm assuming a GitHub repository for the clone command, this might need to be adjusted if it's hosted elsewhere.)*

2. **Install Node.js dependencies:**
   This project uses npm to manage front-end build tools and dependencies, including `autoprefixer` for PostCSS.

   ```bash
   npm install
   ```

3. **Run the development server:**
   Start the Hugo development server with live reloading. This will make the site accessible at `http://localhost:1313/` (or another port if 1313 is in use).

   ```bash
   hugo server
   ```

## Deployment

### Manual Deployment

To generate the static files for deployment:

```bash
hugo
```

This command will compile the website and place all static assets into the `public/` directory. This `public/` directory can then be served by any web server.

### Automated Deployment

The website is automatically built and deployed via a Forgejo Actions workflow (defined in `.forgejo/workflows/hugo.yaml`) whenever changes are pushed to the `main` or `master` branches. The built site is pushed to the `pages` branch of this repository.

## Content

All website content is written in Markdown and located in the `content/` directory. Each subdirectory within `content/posts/` represents a category or series of posts.

## License

This project is licensed under the terms specified in the [LICENSE](LICENSE) file.

## Contributing

Contributions are welcome! If you find a bug or have a suggestion, please open an issue or submit a pull request.
