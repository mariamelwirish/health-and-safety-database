from sqlmodel import create_engine, Session, SQLModel

# SQLite for local testing
DATABASE_URL = "sqlite:///health_safety.db"
engine = create_engine(DATABASE_URL, echo=False)

def get_session():
    return Session(engine)

def create_db_and_tables():
    SQLModel.metadata.create_all(engine)
