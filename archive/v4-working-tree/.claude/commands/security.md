---
description: Conduct a security audit of the code
---

Conduct a detailed security audit of the code according to SECURITY.md.

**IMPORTANT:** Read SECURITY.md first for full context!

**Check the following:**

## 1. Input validation

- [ ] All user input is validated on the server
- [ ] Type-safe validation is used (Zod or similar)
- [ ] String length is checked
- [ ] Data types are checked
- [ ] Formats are checked (email, URL, etc)

## 2. Authentication and authorisation

- [ ] Authentication check in every Server Action
- [ ] Authorisation check (user is allowed to perform the operation)
- [ ] JWT tokens are verified
- [ ] Session management is correct
- [ ] No hardcoded credentials

## 3. SQL Injection

- [ ] Parameterised queries are used
- [ ] No SQL string concatenation
- [ ] An ORM/Query Builder is used (Supabase)
- [ ] Input sanitisation is present

## 4. XSS (Cross-Site Scripting)

- [ ] No use of `dangerouslySetInnerHTML`
- [ ] React is used (auto-escaping)
- [ ] Markdown is rendered safely (react-markdown)
- [ ] No `eval()` or `Function()`

## 5. CSRF (Cross-Site Request Forgery)

- [ ] Server Actions are automatically protected by Next.js
- [ ] API routes use the correct methods
- [ ] Critical operations require confirmation

## 6. Data leakage

- [ ] Secrets are not in the code (.env is used)
- [ ] .env is in .gitignore
- [ ] Errors do not reveal sensitive information
- [ ] Logging contains no secrets
- [ ] The API does not return excess data

## 7. Rate Limiting

- [ ] Public endpoints have rate limiting
- [ ] Brute-force protection
- [ ] DoS protection

## 8. HTTPS and Headers

- [ ] HTTPS is used
- [ ] Security headers are configured (next.config.js)
- [ ] HSTS is enabled
- [ ] CSP is configured

## 9. Dependencies

- [ ] No known vulnerabilities (`npm audit`)
- [ ] Dependencies are up to date
- [ ] Trusted packages are used

## 10. Supabase Security

- [ ] Row Level Security (RLS) is enabled
- [ ] Policies are correct
- [ ] Users see only their own data
- [ ] The anon key is used correctly

**For each problem found, state:**
- ❌ Description of the vulnerability
- 🎯 Severity (Critical/High/Medium/Low)
- 💡 Fix recommendation
- ✅ Example of correct code

**At the end, give:**
- An overall security assessment
- Top-5 critical problems (if any)
- Recommendations for improvement
