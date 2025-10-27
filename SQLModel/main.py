from SQLModel.database import create_db_and_tables
from SQLModel.insertions import insert
from SQLModel import queries


def main():
    create_db_and_tables()
    insert()
    for name, fn in queries.ALL_QUERIES.items():
        rows = fn()
        print(f"=== {name} ({len(rows)}) ===")
        for r in rows:
            print(r)
        print()


if __name__ == "__main__":
    main()
