# AWS S3 Static Website Hosting with Terraform

This project demonstrates how to provision and deploy a fully functional, publicly accessible static website on AWS using **Infrastructure as Code (IaC)** with **Terraform**.

##  Architecture Overview
- **AWS S3 Bucket**: Stores the static website files (`index.html` and `style.css`).
- **S3 Bucket Policy & Public Access Block**: Configured to grant public read access (`s3:GetObject`).
- **S3 Static Website Hosting**: Configured to serve `index.html` as the default entry point.
- **Automated Deployment**: Managed via Terraform using `etag = filemd5(...)` to detect local updates automatically.

##  Project Structure
```text
proiect-site-s3/
├── main.tf          # Terraform infrastructure definition
├── index.html       # Main HTML page
├── style.css        # Website styling sheet
├── .gitignore       # Excludes temporary Terraform files
└── README.md        # Project documentation

#