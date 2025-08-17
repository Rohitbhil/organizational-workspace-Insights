import streamlit as st
import pandas as pd
import plotly.express as px
from sqlalchemy import create_engine
import subprocess
from pyngrok import ngrok

connection_url = create_engine("postgresql://postgres:rohit1981@localhost:5432/orgpg_db")

# Set the page to wide layout for better dashboard presentation
st.set_page_config(layout="wide")
st.title("📊 Organisation Dashboard")

# --- Sidebar Filters ---
# Fetch list of unique organization IDs to populate the selectbox
org_df = pd.read_sql("SELECT DISTINCT org_id FROM organisations", connection_url)
org_ids = org_df["org_id"].sort_values().tolist()
org_ids.insert(0, 'All')
selected_org_id = st.sidebar.selectbox("Select Organisation ID", org_ids)

# Fetch workspaces based on the selected organization
if selected_org_id == 'All':
    workspace_df = pd.read_sql("SELECT DISTINCT id, name FROM workspaces;", connection_url)
else:
    workspace_df = pd.read_sql(f"SELECT DISTINCT id, name FROM workspaces WHERE org_id = '{selected_org_id}';", connection_url)

# Populate a dictionary for the multiselect widget
workspace_options = {'All': 'All'}
for index, row in workspace_df.iterrows():
    workspace_options[row['id']] = row['name']

selected_workspace_ids = st.sidebar.multiselect(
    "Select Workspace",
    options=list(workspace_options.keys()),
    format_func=lambda x: workspace_options[x],
    default=['All']
    
)

# Build the workspace filter for the SQL queries
def build_workspace_filter(alias):
    """
    Constructs a SQL WHERE clause fragment to filter by selected workspace IDs.
    
    Args:
        alias (str): The alias used for the 'workspaces' table in the query.
        
    Returns:
        str: A string like " AND alias.id IN ('id1', 'id2')" or an empty string.
    """
    if 'All' not in selected_workspace_ids:
        safe_ids = ", ".join([f"'{wid}'" for wid in selected_workspace_ids])
        return f" AND {alias}.id IN ({safe_ids})"
    return ""

# Create filter strings for different table aliases used in the queries
workspace_filter_w = build_workspace_filter("W")  # For queries that alias workspaces as W
workspace_filter_a = build_workspace_filter("a")  # For queries that alias workspaces as a
workspace_filter_b = build_workspace_filter("b")  # For queries that alias workspaces as b


# --- Dashboard Columns and Charts ---
col1, col2, col3 = st.columns(3)

# Chart 1: Workspaces per Organization
with col1:
    st.subheader("Workspaces per Organization")
    if selected_org_id == "All":
        # Corrected query: Using 'b' as the alias for workspaces and applying the filter
        query1 = f'''
            SELECT a.org_id, a.name, COUNT(b.org_id) AS total_workspace
            FROM organisations AS a
            JOIN workspaces AS b ON a.org_id = b.org_id
            WHERE 1=1 {workspace_filter_b}
            GROUP BY a.org_id, a.name
            ORDER BY a.org_id;
        '''
    else:
        # Corrected query: Using 'b' as the alias for workspaces and applying the filter
        query1 = f'''
            SELECT a.org_id, a.name, COUNT(b.org_id) AS total_workspace
            FROM organisations AS a
            JOIN workspaces AS b ON a.org_id = b.org_id
            WHERE a.org_id = '{selected_org_id}' {workspace_filter_b}
            GROUP BY a.org_id, a.name
            ORDER BY a.org_id;
        '''
    df1 = pd.read_sql_query(query1, connection_url)
    if not df1.empty:
        fig1 = px.pie(
            values=df1["total_workspace"],
            names=df1["name"],
            title='1',
           
        )
        fig1.update_layout(title_x=0.6)
        fig1.update_traces(texttemplate=' %{value}')
        st.plotly_chart(fig1, use_container_width=True)
    else:
        st.warning("No data for this selection.")

# Chart 2: Workspaces in Each Timezone
with col2:
    st.subheader("Workspaces in Each Timezone")
    # Corrected query: Using the correct filter for alias 'a'
    query2 = f'''
        SELECT time_zone, name 
        FROM workspaces AS a
        WHERE a.org_id = '{selected_org_id}' {workspace_filter_a}
        ORDER BY org_id;
    ''' if selected_org_id != 'All' else f'''
        SELECT time_zone, name 
        FROM workspaces AS a
        WHERE 1=1 {workspace_filter_a}
        ORDER BY org_id;
    '''
    df2 = pd.read_sql_query(query2, connection_url)
    if not df2.empty:
        fig2 = px.sunburst(
            df2,
            path=["time_zone", "name"],
             title='2',
           
        )
        fig2.update_layout(title_x=0.4)
        st.plotly_chart(fig2, use_container_width=True)
    else:
        st.warning("No data for this selection.")

# Chart 3: Active vs Inactive Workspaces
with col3:
    st.subheader("Active vs Inactive Workspaces")
    # Corrected query: Using 'a' as the alias for workspaces and the corresponding filter
    query3 = f'''
        SELECT name, org_id, active 
        FROM public.workspaces AS a
        WHERE a.org_id = '{selected_org_id}' {workspace_filter_a}
    ''' if selected_org_id != 'All' else f'''
        SELECT name, org_id, active 
        FROM public.workspaces AS a
        WHERE 1=1 {workspace_filter_a}
    '''
    df3 = pd.read_sql_query(query3, connection_url)
    if not df3.empty:
        value_counts = df3['active'].value_counts()
        labels = value_counts.index.map({True: 'Active', False: 'Inactive'})
        values = value_counts.values
        fig3 = px.pie(
            names=labels,
            values=values,
             title='3',
            
        )
        fig3.update_layout(title_x=0.4)
        fig3.update_traces(texttemplate='%{value}')
        st.plotly_chart(fig3, use_container_width=True)
    else:
        st.warning("No data for this selection.")

col4, col5, col6 = st.columns(3)

# Chart 4: No_of_Variable in Each workspace
with col4:
    # Corrected query: Using the correct filter for alias 'a'
    st.subheader('No_of_Variable in Each workspace')      
    query4 = f'''
        SELECT a.org_id, a.name, COUNT(b.name_label) AS no_of_variables
        FROM public.workspaces AS a
        JOIN public.workspace_variables AS b ON b.workspace_id = a.id
        WHERE a.org_id = '{selected_org_id}' {workspace_filter_a}
        GROUP BY a.org_id, a.name;
    ''' if selected_org_id != 'All' else f'''
        SELECT a.org_id, a.name, COUNT(b.name_label) AS no_of_variables
        FROM public.workspaces AS a
        JOIN public.workspace_variables AS b ON b.workspace_id = a.id
        WHERE 1=1 {workspace_filter_a}
        GROUP BY a.org_id, a.name;
    '''
    df4 = pd.read_sql_query(query4, connection_url)

    if not df4.empty:
        st.dataframe(df4, use_container_width=True)
    else:
        st.warning("No data available for this selection in Chart 4.")


# Chart 5: No_of_sites in Each workspace
with col5:
    st.subheader("Sites per Workspace")
    # Corrected query: The JOIN condition is now on workspace ID, and the filter is applied.
    if selected_org_id == "All":
        query5 = f'''
            SELECT a.org_id, a.name, COUNT(b.name) AS no_of_sites
            FROM public.workspaces AS a
            JOIN public.workspace_sites AS b ON a.id = b.workspace_id
            WHERE 1=1 {workspace_filter_a}
            GROUP BY a.org_id, a.name;
        '''
    else:
        query5 = f'''
            SELECT a.org_id, a.name, COUNT(b.name) AS no_of_sites
            FROM public.workspaces AS a
            JOIN public.workspace_sites AS b ON a.id = b.workspace_id
            WHERE a.org_id = '{selected_org_id}' {workspace_filter_a}
            GROUP BY a.org_id, a.name;
        '''

    df5 = pd.read_sql_query(query5, connection_url)

    if not df5.empty:
        fig = px.bar(
            x=df5["name"], 
            y=df5["no_of_sites"], 
           
            labels={'x': 'Workspaces', 'y': 'Number of Sites'},
             title='5',
        )
        fig.update_layout(title_x=0.4)
        fig.update_traces(marker_color='red')
        st.plotly_chart(fig, key="chart 5")
    else:
        st.warning("No data available for this selection in Chart 5.")

# Chart 6: No_of_rules in Each variable
with col6:
    st.subheader("Rules per Variable")
    # Corrected query: The JOIN condition is now on variable ID, and the filter is applied.
    if selected_org_id == "All":
     query6 = f'''
        SELECT a.workspace_id,a.org_id, a.name_label, COUNT(b.name) AS no_of_rules
        FROM public.workspace_variables AS a
        JOIN public.workspace_rules AS b ON a.workspace_id = b.workspace_id
        WHERE 1=1 {workspace_filter_a}
        GROUP BY a.name_label, a.org_id,a.workspace_id;
    '''
    else:
     query6 = f'''
        SELECT a.workspace_id,a.org_id, a.name_label, COUNT(b.name) AS no_of_rules
        FROM public.workspace_variables AS a
        JOIN public.workspace_rules AS b ON a.workspace_id = b.workspace_id
        WHERE a.org_id = {(selected_org_id)} {workspace_filter_a}
        GROUP BY a.name_label, a.org_id,a.workspace_id ;
    '''

    df6 = pd.read_sql_query(query6, connection_url)

    if not df6.empty:
        fig = px.bar(
            x=df6["name_label"], 
            y=df6["no_of_rules"], 
            labels={'x': 'Variable', 'y': 'Number of Rules'},
             title='6',
        )
        fig.update_layout(title_x=0.4)
        fig.update_traces(marker_color='orange')
        st.plotly_chart(fig, key="chart 6")
    else:
        st.warning("No data available for this selection in Chart 6.")
        
col7,col8,col9=st.columns(3)        
 
 #Chart 7: Total items in  each order
with col7:
    st.subheader("Total items in each order")

    # Base query
    query7 = f'''
         SELECT a.org_id, 
               a.dish_code, 
               a.dish_name AS Name_of_Dish, 
               SUM(b.quantity) AS Total_orders
        FROM workspace_food_dishes AS a
        JOIN workspace_food_order_items AS b
            ON a.dish_code = b.dish_code
        WHERE a.org_id = '{selected_org_id}' {workspace_filter_a}
         GROUP BY a.dish_name, a.dish_code, a.org_id
        ORDER BY a.dish_code;
    ''' if selected_org_id != 'All' else f'''
         SELECT a.org_id, 
               a.dish_code, 
               a.dish_name AS Name_of_Dish, 
               SUM(b.quantity) AS Total_orders
        FROM workspace_food_dishes AS a
        JOIN workspace_food_order_items AS b
            ON a.dish_code = b.dish_code
             WHERE 1=1 {workspace_filter_a}
             GROUP BY a.dish_name, a.dish_code, a.org_id
        ORDER BY a.dish_code;
        ;
    '''
    df7 = pd.read_sql_query(query7, connection_url)

    if not df7.empty:
        st.dataframe(df7, use_container_width=True)
    else:
        st.warning("No data available for this selection in Chart 7.")

    

 
 # Chart 8:NO of actions in each workspace 


with col8:
    st.subheader('NO of actions in each workspace')
    if selected_org_id == "All":
        query8 = f'''
            SELECT a.org_id, a.name AS workspace_name, COUNT(b.action_type) AS total_actions
            FROM workspaces AS a
            JOIN workspace_actions AS b ON a.id = b.workspace_id
            WHERE 1=1 {workspace_filter_a}
            GROUP BY a.name, a.org_id;
        '''
    else:
        query8 = f'''
            SELECT a.org_id, a.name AS workspace_name, COUNT(b.action_type) AS total_actions
            FROM workspaces AS a
            JOIN workspace_actions AS b ON a.id = b.workspace_id
            WHERE a.org_id = {selected_org_id} {workspace_filter_a}
            GROUP BY a.name, a.org_id;
        '''

    df8 = pd.read_sql_query(query8, connection_url)

    # Display the DataFrame in Streamlit
    st.dataframe(df8, use_container_width=True)
    
   
# 9 users in each workspace
with col9:
    st.subheader('Users in each workspace')
    
    if selected_org_id == "All":
        query9 = f'''
            SELECT a.name AS workspace_name, COUNT(b.user_id) AS total_users
            FROM workspaces AS a
            JOIN workspace_users AS b ON a.id = b.workspace_id
            WHERE 1=1 {workspace_filter_a}
            GROUP BY a.name;
        '''
    else:
        query9 = f'''
            SELECT a.name AS workspace_name, COUNT(b.user_id) AS total_users
            FROM workspaces AS a
            JOIN workspace_users AS b ON a.id = b.workspace_id
            WHERE a.org_id = {selected_org_id} {workspace_filter_a}
            GROUP BY a.name;
        '''
    
    df9 = pd.read_sql_query(query9, connection_url)
    st.dataframe(df9, use_container_width=True)
 
 
col10,col11,col12=st.columns(3)

# Chart 10: No_of_actions in Each Rule
with col10:
    st.subheader('No_of_actions in Each Rule')   
    
    if selected_org_id == "All":
        query10 = f'''
            SELECT a.name AS workspace_name, COUNT(b.name) AS total_reports
            FROM workspaces AS a
            JOIN workspace_reports AS b ON a.id = b.workspace_id
            WHERE 1=1 {workspace_filter_a}
            GROUP BY a.name;
        '''
    else:
        query10 = f'''
            SELECT a.name AS workspace_name, COUNT(b.name) AS total_reports
            FROM workspaces AS a
            JOIN workspace_reports AS b ON a.id = b.workspace_id
            WHERE a.org_id = {selected_org_id} {workspace_filter_a}
            GROUP BY a.name;
        '''
    
    df10 = pd.read_sql_query(query10, connection_url)
    st.dataframe(df10, use_container_width=True)
 
 
 # 11 location per workspace 
with col11:
    st.subheader('Location per workspace')   
    
    if selected_org_id == "All":
        query11 = f'''
            SELECT a.org_id, a.name, COUNT(b.name) AS no_of_locations
            FROM public.workspaces AS a
            JOIN public.workspace_locations AS b ON b.workspace_id = a.id
            WHERE 1=1 {workspace_filter_a}
            GROUP BY a.org_id, a.name;
        '''
    else:
        query11 = f'''
            SELECT a.org_id, a.name, COUNT(b.name) AS no_of_locations
            FROM public.workspaces AS a
            JOIN public.workspace_locations AS b ON b.workspace_id = a.id
            WHERE a.org_id = {selected_org_id} {workspace_filter_a}
            GROUP BY a.org_id, a.name;
        '''
    
    df11 = pd.read_sql_query(query11, connection_url)
    st.dataframe(df11, use_container_width=True)
    
# 12 dashboard per workspace
with col12:
    st.subheader('Dashboard per workspace')      

    if selected_org_id == "All":
        query12 = f'''
            SELECT a.org_id, a.name, COUNT(b.name) AS no_of_dashboard
            FROM public.workspaces AS a
            JOIN public.workspace_dashboards AS b ON b.workspace_id = a.id
            WHERE 1=1 {workspace_filter_a}
            GROUP BY a.org_id, a.name;
        '''
    else:
        query12 = f'''
            SELECT a.org_id, a.name, COUNT(b.name) AS no_of_dashboard
            FROM public.workspaces AS a
            JOIN public.workspace_dashboards AS b ON b.workspace_id = a.id
            WHERE a.org_id = {selected_org_id} {workspace_filter_a}
            GROUP BY a.org_id, a.name;
        '''
    
    df12 = pd.read_sql_query(query12, connection_url)
    st.dataframe(df12, use_container_width=True)



col13,col14,col15=st.columns(3)
 # 13 user of each rule
with col13:
    st.subheader('User of each rule')     

    if selected_org_id == "All":
        query13 = f'''
            SELECT a.org_id, a.user_id, COUNT(b.name) AS no_of_rules
            FROM public.workspace_users AS a
            JOIN public.workspace_rules AS b ON b.workspace_id = a.workspace_id
            WHERE 1=1 {workspace_filter_a}
            GROUP BY a.org_id, a.user_id;
        '''
    else:
        query13 = f'''
            SELECT a.org_id, a.user_id, COUNT(b.name) AS no_of_rules
            FROM public.workspace_users AS a
            JOIN public.workspace_rules AS b ON b.workspace_id = a.workspace_id
            WHERE a.org_id = {selected_org_id} {workspace_filter_a}
            GROUP BY a.org_id, a.user_id;
        '''
    
    df13 = pd.read_sql_query(query13, connection_url)
    st.dataframe(df13, use_container_width=True)

#14 No_of_devices in Each workspace
with col14:
    st.subheader(' No_of_devices in Each workspace')  
    if selected_org_id == "All":
        query14 = f'''
            SELECT a.org_id, a.name, COUNT(b.name) AS no_of_devices
            FROM public.workspaces AS a
            JOIN public.workspace_devices AS b ON a.id = b.workspace_id
            WHERE 1=1 {workspace_filter_a}
            GROUP BY a.org_id, a.name;
        '''
    else:
        query14 = f'''
            SELECT a.org_id, a.name, COUNT(b.name) AS no_of_devices
            FROM public.workspaces AS a
            JOIN public.workspace_devices AS b ON a.id = b.workspace_id
            WHERE a.org_id = {selected_org_id} {workspace_filter_a}
            GROUP BY a.org_id, a.name;
        '''

    df14 = pd.read_sql_query(query14, connection_url)

    if not df14.empty:
        fig = px.bar(
            df14,
            x="name", 
            y="no_of_devices", 
    
            labels={'name': 'Workspaces', 'no_of_devices': 'No_of_Devices'},
            width=500,
            height=500,
             title='14',
            
        )
        fig.update_layout(title_x=0.4)
        fig.update_traces(marker_color='green')
        st.plotly_chart(fig, key="chart_4")
    else:
        st.warning("No data available for this organisation in Chart 4.")
        
#15 no_of widgets  per dashboard 
with col15:
    st.markdown('<h5 style="text-align: center;">This no_of widgets  per dashboard </h5>', unsafe_allow_html=True)
    if selected_org_id == "All":
        query12 = f'''
            SELECT a.name, COUNT(b.chart_type) AS no_of_widgets
            FROM public.workspace_dashboards AS a
            JOIN public.workspace_dashboard_widgets AS b 
                ON a.org_id = b.org_id
            WHERE 1=1 {workspace_filter_a}
            GROUP BY a.name;
        '''
    else:
        query12 = f'''
            SELECT a.name, COUNT(b.chart_type) AS no_of_widgets
            FROM public.workspace_dashboards AS a
            JOIN public.workspace_dashboard_widgets AS b 
                ON a.org_id = b.org_id
            WHERE a.org_id = {selected_org_id} {workspace_filter_a}
            GROUP BY a.name;
        '''

    df15 = pd.read_sql_query(query12, connection_url)

    if not df15.empty:
        fig = px.bar(
            x=df15["name"],  
            y=df15["no_of_widgets"],  
            
            labels={'x': 'Dashboard', 'y': 'No_of_widgets'},
             title='15',
        )
        fig.update_layout(title_x=0.4)
        fig.update_traces(marker_color='purple')
        st.plotly_chart(fig, key="chart 15")
    else:
        st.warning("No dashboard widget data available for this organisation in Chart 12.")


col16,col17,col18=st.columns(3)
# 16 Asset per workspace

with col16:
    st.subheader('Asset per workspace')

    if selected_org_id == 'All':
        query16 = f"""
            select a.id, a.name, count (b.asset_name) from workspaces as a join workspace_assets as b
on a.id = b.workspace_id 
WHERE 1=1 {workspace_filter_a}
group by a.name, a.id 
order by a.id;
            
        """
    else:
        query16 = f"""
            select a.id, a.name, count (b.asset_name) from workspaces as a join workspace_assets as b
on a.id = b.workspace_id 
WHERE a.org_id = {selected_org_id} {workspace_filter_a}
group by a.name, a.id 
order by a.id;
            
            
        """

    df16 = pd.read_sql_query(query16, connection_url)

    if not df16.empty:
        st.dataframe(df16, use_container_width=True)
    else:
        st.warning("No data available for this selection in Chart 16.")
 #   checklist per workspace    
with col17:
    st.subheader('Checklist per workspace')      

    # Base query
    query17 = '''
        SELECT a.id, a.name, COUNT(b.name) AS total_checklists
        FROM workspaces AS a
        JOIN workspace_checklists AS b ON a.id = b.workspace_id
        WHERE 1=1
    '''

    # Add filters dynamically
    if selected_org_id != 'All':
        query17 += f" AND a.org_id = {selected_org_id}"
    query17 += f" {workspace_filter_a}"

    # Finish query
    query17 += '''
        GROUP BY a.name, a.id
        ORDER BY a.id;
    '''

    df17 = pd.read_sql_query(query17, connection_url)

    if not df17.empty:
        st.dataframe(df17, use_container_width=True)
    else:
        st.warning("No data available for this selection in Chart 17.")