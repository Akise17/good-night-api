# Good Night API

A **RESTful Rails API** for tracking and sharing sleep patterns. Users can log their sleep sessions, follow other users, and view summarized sleep data from their network.

---

## 🚀 Features

- User authentication
- Track sleep sessions (`clock_in` / `clock_out`)
- Follow other users
- View sleep data from followings
- Paginated API responses
- Fully testable with Minitest

---

## 🛠️ Development Setup

### Option 1: Using Docker

1. **Clone the repository**
```bash
git clone https://github.com/Akise17/good-night-api.git
cd good-night-api
```
2. **Run seed**
```bash
docker-compose run --rm api bin/rails db:seed        
```
3. **Run application**
```bash
docker-compose up --build
```
4. **Testing**
```bash
docker-compose run --rm api bin/rails db:test:prepare
```
After database ready simply run
```bash
docker-compose run --rm api bin/rails test
```

### Option 2: Traditional Setup
**Prequisite**
- Database already setup
- ruby 3.3.6 Installed

1. **Clone the repository**
```bash
git clone https://github.com/Akise17/good-night-api.git
cd good-night-api
```
2. **Run bundle**
```bash
bundle
```

2. **Setup database**
```bash
rails db:create
rails db:migrate
rails db:seed        
```

3. **Run application**
```bash
rails s
```
4. **Testing**
```bash
rails db:test:prepare
```
After database ready simply run
```bash
rails test
```

## 🚀 Usage
API can be access on 
```bash
localhost:3000
```
Postman Collection API documentation:
https://documenter.getpostman.com/view/18203091/2sB3HgQP7w

## 🚀 Production
You can test on Our production env deployed on AWS region singapore
```bash
https://good-night.iotaku.tech/api/v1
```