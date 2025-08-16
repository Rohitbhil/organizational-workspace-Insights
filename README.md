# Organizational Workspace Analytics

**Project by:** Rohit Bhil & Sumit Daf  
**Internship at:** StatStream.ai

**Description:**  

An interactive Streamlit dashboard for analyzing organizational and workspace data using PostgreSQL.

---

## Project Overview

The **Organizational Workspace Analytics** project is a data visualization dashboard built using **Streamlit** and **PostgreSQL**, designed to provide insights into organizational data. The project focuses on handling a complex database schema and enabling interactive data exploration through dynamic dashboards.  

During this internship at StatStream.ai, we were provided a **PostgreSQL database schema containing 69 tables**. Our task was to populate the database with realistic dummy data and create an interactive Streamlit dashboard to answer predefined analytical questions.

---
## Project Insights

This project provides an interactive Streamlit dashboard to explore and analyze complex organizational and workspace data. By connecting a PostgreSQL database with 69 tables, it enables dynamic filtering, interactive visualizations, and key metrics to gain actionable insights into organizational performance and workspace activity.

---
## Database Schema

The PostgreSQL database consists of **69 tables** covering **organizations, workspaces, users**, and related entities. This schema provides a structured foundation for managing data and enables interactive analytics and visualization.

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
- **Data Handling:** Pandas, NumPy  
- **Visualization:** Plotly, Matplotlib, Seaborn  

---

## Project Structure

organizational-workspace-analytics/

│── app.py # Main Streamlit application   
│── requirements.txt # Python dependencies  
│── data/ # Optional: sample CSVs or data files  
│── images/ # Dashboard screenshots  
└── README.md # Project description 


---

## How to Run

1. **Clone the repository:**
   - git clone https://github.com/Rohitbhil/organizational-workspace-analytics.git
   - cd organizational-workspace-analytics


2. ** Install dependencies:**
   - All required Python packages are listed in requirements.txt. Run the following command:
   - pip install -r requirements.txt


3. **Setup PostgreSQL database:**
   - Create the database using pgAdmin4.
   - insert dummy data into all 69 tables.

4. **Update database connection in app.py:**
   - from sqlalchemy import create_engine
   - engine = create_engine('postgresql://username:password@localhost:5432/your_database')


6. **Run the Streamlit app:**
   - streamlit run app.py


