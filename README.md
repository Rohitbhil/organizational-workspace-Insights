# Organizational Workspace Analytics

Project by: Rohit Bhil & Sumit Daf

Internship at : XYZ.ai  

## Project Overview

The **Organizational Workspace Analytics** project is a **data visualization dashboard** built using **Streamlit** and **PostgreSQL**, designed to provide insights into organizational data. The project focuses on handling a complex database schema and enabling interactive data exploration through dynamic dashboards.  

During this internship at **XYZ.ai**, we were provided with a **PostgreSQL database schema containing 69 tables**. Our task was to populate the database with realistic dummy data and create an interactive Streamlit dashboard to answer predefined analytical questions.

---

## Key Features

### Database Population
- Inserted realistic dummy data into all 69 PostgreSQL tables using **pgAdmin4**.

### Database Connection
- Connected the PostgreSQL database to Python using **SQLAlchemy** (`create_engine`).

### Interactive Dashboard
- **Organization Dropdown** – Select one organization.  
- **Workspace Dropdown** – Select one or multiple workspaces corresponding to the selected organization.  
- **Dynamic Filtering** – All graphs and data tables update automatically based on selected organization and workspace(s).

### Data Visualizations
- Interactive charts and graphs displaying insights across organizations and workspaces.  
- Summary tables and KPIs derived from the database.

---

## Tech Stack

- **Backend / Database:** PostgreSQL, SQLAlchemy, pgAdmin4  
- **Frontend / Dashboard:** Python, Streamlit  
- **Data Handling:** Pandas
- **Visualization:** Plotly
