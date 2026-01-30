from fastapi import FastAPI

from app.routes.ec2 import ec2_router

app = FastAPI()

app.include_router(ec2_router,)