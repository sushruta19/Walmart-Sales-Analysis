# Walmart Sales Data Analysis

This project involves end-to-end analysis of a Walmart sales dataset, including data cleaning, exporting to a relational database (MySQL), and executing SQL queries for deriving business insights.

---

## Project Overview

The key goals of this project are to:
- Perform data cleaning and transformation using **Pandas** in **Jupyter Notebook**
- Export the cleaned dataset to a **MySQL relational database** using `SQLAlchemy` and `PyMySQL`
- Use **SQL queries** to derive meaningful business insights, such as:
  - Top-performing product categories
  - Peak sales times and shifts
  - Year-over-year revenue changes per branch
  - Revenue trends and customer behavior
  - Identifying best-selling product categories.
  - Sales performance by time, city, and payment method.
  - Profit margin analysis by branch and category.

---

## Dataset

- **Source**: Kaggle Walmart sales data (~10,000 rows)
- **Format**: CSV
- **Columns include**:
  - `invoice_id`, `branch`, `city`, `category`, `unit_price`, `quantity`
  - `date`, `time`, `payment_method`, `rating`, `profit_margin`, `total`

---

## Tools & Technologies Used

| Tool          | Purpose                               |
|---------------|----------------------------------------|
| `pandas`      | Data cleaning and manipulation         |
| `JupyterLab`  | Interactive development environment    |
| `SQLAlchemy`  | Database abstraction/connection layer  |
| `PyMySQL`     | MySQL database connector               |
| `MySQL`       | Relational database and SQL querying   |

---
## Setup

```bash
# Clone the repo
git clone https://github.com/sushruta19/Walmart-Sales-Analysis.git
cd Walmart-Sales-Analysis

# Create virtual environment
python -m venv venv
venv\Scripts\activate.bat   # On Windows(Command Prompt)
source venv/bin/activate    # On Linux(Bash)

# Install dependencies
pip install -r requirements.txt

# Run Jupyter-lab or notebook
jupyter-lab
```

