# 🧩 Team Projects API (Rails 8, Multi-Tenant)

A backend-only **Rails 8 API** that supports **multi-tenant team project management**.  
Authentication is handled with **Devise + JWT**, and each tenant (team) has isolated access to its own projects and tasks.

Currently a work in progess.


## 🚀 Features

- Multi-tenant architecture using **acts_as_tenant**
- JWT authentication with **devise + devise-jwt**
- Organized routes under `/api/v1`
- JSON:API-compliant serialization using **jsonapi-serializer**
- Task ordering with **acts_as_list**
- Active Storage for attachments
- Tested with **RSpec**, **FactoryBot**, and **Shoulda-Matchers**

## 🧱 Tech Stack

| Component      | Technology                         |
|----------------|------------------------------------|
| Framework      | Ruby on Rails 8                    |
| Database       | PostgreSQL                         |
| Authentication | Devise + devise-jwt                |
| Multi-Tenancy  | acts_as_tenant                     |
| Serialization  | jsonapi-serializer                 |
| Job/Cache Libs | solid_queue, solid_cache           |
| Tests          | RSpec, FactoryBot, Faker           |

## 🏗️ Quickstart (Development)

```bash
# Install dependencies
bundle install

# Create and migrate the database
rails db:create db:migrate db:seed

# Run the test suite
bundle exec rspec

# Start the server
rails s

Server will start on http://localhost:3000 by default.

## Coming Soon

Planned features to be implemented.

### Core Enhancements

#### Invitations & Team Management
- Allow team leaders to invite members via email.
- Manage team roles (Admin, Member, Guest).
- Support team ownership transfer and member removal.

####  Project Roles & Permissions
- Define role-based permissions at the project level (Project Lead, Editor, Viewer).
- Restrict editing, deletion, and assignment actions by role.
- Extend authorization checks across tasks and activity logs.

#### Task Comments & Attachments
- Add threaded comments for task discussions.
- Upload and associate files using Active Storage.
- Include mention support (`@username`) for comment notifications.

#### Subtasks
- Support task hierarchies (parent ↔ subtask relationships).
- Allow nested completion tracking and progress rollup.
- Integrate subtasks into activity feeds and productivity reports.

#### Project Activity Feed / Audit Log
- Log project changes: creation, completion, assignment, comment added, etc.
- Provide a `/api/v1/activity` endpoint to fetch activity for a team or project.
- Use background jobs for efficient event recording.

---

### API & Productivity Tools

#### API Documentation (Swagger / RSwag)
- Auto-generate OpenAPI 3.0 spec from request specs.
- Interactive API explorer at `/api-docs`.
- Keep documentation synced with test coverage for backend–frontend alignment.

#### Search Endpoints
- Add full-text search using `pg_search` or `searchkick`.
- Enable keyword filtering across projects, tasks, and comments.
- Combine with labels and priorities for advanced filtering.

#### Notifications System
- In-app and email notifications for task updates, mentions, and due dates.
- Support customizable notification preferences per user.
- Future: WebSocket or Action Cable integration for real-time updates.

---

### Insights & Reporting

#### Team Productivity Reports
- Aggregate metrics for completed tasks, deadlines met, and active projects.
- Generate JSON and optional PDF exports per team.
- Schedule automated weekly reports via background jobs.

#### Task Dependencies
- Model “blocked by” and “depends on” relationships between tasks.
- Prevent task completion until dependencies are resolved.
- Visualize dependency chains in reports or frontend timeline views.

#### Labels & Tagging
- Add customizable labels for tasks and projects (e.g., `#design`, `#urgent`).
- Enable color-coded filtering by label.
- Include label usage analytics in productivity reports.

---

*These features are currently in design and implementation. Contributions and feedback are always welcome!* 
