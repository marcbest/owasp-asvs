# OWASP ASVS Portal

The **OWASP ASVS Portal** is an open-source web application that simplifies the implementation, tracking, and validation of OWASP Application Security Verification Standard (ASVS) requirements throughout your development lifecycle.

---

## Features

- ✅ Interactive OWASP ASVS requirement tracking  
- 🔐 Multiple assessment levels (L1, L2, L3)  
- 📊 Project progress visualization  
- 📄 Export to PDF and CSV formats  
- 🔗 Secure sharing of assessments  
- 👥 Team collaboration with role-based access control  

---

## Requirements

- Ruby `3.2.0+`  
- Rails `7.0.0+`  
- PostgreSQL `14+`  
- Node.js `18+` and Yarn for JavaScript dependencies  

---

## Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/yourusername/owasp-asvs.git
   cd owasp-asvs
   ```

2. **Install dependencies:**

   ```bash
   bundle install
   yarn install
   ```

3. **Set up the database:**

   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Start the server:**

   ```bash
   bin/dev
   ```

5. Visit `http://localhost:3000` in your browser.

---

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository  
2. Create your feature branch:

   ```bash
   git checkout -b my-new-feature
   ```

3. Commit your changes:

   ```bash
   git commit -am 'Add some feature'
   ```

4. Push to the branch:

   ```bash
   git push origin my-new-feature
   ```

5. Create a new Pull Request  

---

## License

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.

---

## Acknowledgments

- [OWASP Application Security Verification Standard Project](https://owasp.org/www-project-application-security-verification-standard/)
