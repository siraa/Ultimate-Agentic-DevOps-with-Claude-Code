# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.


## Project Overview

Static HTML/CSS portfolio website deployed to AWS using S3 and CloudFront, provisioned with Terraform, and automated via GitHub Actions.

**Key requirement**: Site must remain live for 24 hours with visible ownership proof in the footer.

## Architecture

- Pure HTML5 and CSS3
- No JavaScript
- No build step
- No framework

## Commands

- terraform init
- terraform plan
- terraform apply

## Conventions

- All infrastructure changes go through Terraform — never modify AWS resources manually
- No JavaScript in this project
- CSS uses mobile-first approach with breakpoints at 900px, 768px, and 600px

## Safety

Never put secrets in this file. No API keys, passwords, or AWS credentials.

## File Structure

- **index.html** — Main portfolio page. Contains all sections (hero, about, services, courses, books, community, contact) and links to secondary pages. DOM manipulation (hamburger menu, scroll to sections) uses inline JavaScript.
- **style.css** — Shared stylesheet for index.html. Uses CSS Grid/Flexbox for responsive layout, animations (fadeUp), and color scheme (dark navbar with yellow accent #facc15).
- **privacy.html** — Privacy policy page. Self-contained with inline CSS (dark theme). No external dependencies beyond Font Awesome icon library.
- **terms.html** — Terms of service page. Same structure as privacy.html.
- **images/** — Logo, profile photo, book covers, course thumbnails, and certificate images. All images are lazy-loaded.

## Before Deployment: Ownership Proof

**REQUIRED**: Edit the footer in `index.html` (line 604) to add your deployment details:

```html
<!-- Change this: -->
<p>Crafted with <span>cloud</span> excellence by Pravin Mishra</p>

<!-- To this (example): -->
<p><strong>Deployed by:</strong> DMI Cohort 3 | Tayssir Oueslati | Group 2 | Week 2 | 05-07-2026</p>
``` 
```bash
# SSH into Ubuntu VM
ssh ubuntu@<your-public-ip>

# Install Nginx
sudo apt update && sudo apt install -y nginx

# Clone repo or upload files
git clone <repo-url> && cd Ultimate-Agentic-DevOps-with-Claude-Code

# Copy to Nginx web root
sudo cp -r * /var/www/html/
sudo chown -R www-data:www-data /var/www/html/

# Start Nginx
sudo systemctl start nginx && sudo systemctl enable nginx

# Access: http://<your-public-ip>
```

Site will auto-serve `index.html` at the root; `/privacy` and `/terms` are accessible via links in footer.



## Customization Common Tasks

1. **Change portfolio name**: Update `<title>` tag in all .html files and hero/about section text
2. **Update contact info**: Edit contact section in index.html (lines 485–545)
3. **Change colors**: Look for #facc15 (yellow accent) and #111827 (dark background) in style.css
4. **Update social links**: Edit footer social links (lines 565–573 in index.html)
5. **Replace images**: Drop new images in the `images/` folder and update src paths in HTML

## Key Design Notes

- **Responsive**: Mobile hamburger menu activates below ~768px (check style.css for media queries)
- **Icon library**: Uses Font Awesome 6.5.0 (CDN-loaded, line 10 of index.html). If icons break, verify CDN link is accessible
- **External links**: Course links to Udemy and books to Amazon; verify these URLs remain valid
- **Animations**: CSS keyframes on book cards and trust stats (lines 56–89 of style.css) trigger on scroll/load
- **No backend**: All content is static HTML. Forms do not actually submit anywhere.

## Verification Checklist Before 24-Hour Deployment

- [ ] Footer ownership proof added and visible in browser
- [ ] Site loads at `http://<public-ip>` without 404 errors
- [ ] All images display (no broken image icons)
- [ ] Navigation links scroll to correct sections
- [ ] Mobile hamburger menu works
- [ ] External links (Udemy, Amazon, social) are reachable
- [ ] Nginx is running and enabled (won't restart if VM reboots)
