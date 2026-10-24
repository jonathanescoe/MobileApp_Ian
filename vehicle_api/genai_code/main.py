from itertools import count

from fastapi import FastAPI, HTTPException, Response, status
from pydantic import BaseModel, ConfigDict, Field


app = FastAPI(
    title="Vehicle Manufacturers API",
    description="An in-memory CRUD API for manufacturers and their vehicles.",
)

# These dictionaries act as our database.
# All records disappear when the server restarts.
manufacturers = {}
vehicles = {}

manufacturer_ids = count(1)
vehicle_ids = count(1)


# Models validate incoming data.
class ManufacturerInput(BaseModel):
    model_config = ConfigDict(str_strip_whitespace=True, extra="forbid")

    name: str = Field(min_length=1, max_length=100)
    country: str = Field(min_length=1, max_length=100)


class Manufacturer(ManufacturerInput):
    id: int


class VehicleInput(BaseModel):
    model_config = ConfigDict(str_strip_whitespace=True, extra="forbid")

    manufacturer_id: int = Field(gt=0)
    model: str = Field(min_length=1, max_length=100)
    year: int = Field(ge=1886, le=2100)


class Vehicle(VehicleInput):
    id: int


# Helper functions return a record or a 404 error.
def find_manufacturer(manufacturer_id: int) -> Manufacturer:
    if manufacturer_id not in manufacturers:
        raise HTTPException(
            status_code=404,
            detail="Manufacturer not found",
        )
    return manufacturers[manufacturer_id]


def find_vehicle(vehicle_id: int) -> Vehicle:
    if vehicle_id not in vehicles:
        raise HTTPException(
            status_code=404,
            detail="Vehicle not found",
        )
    return vehicles[vehicle_id]


@app.get("/", tags=["Home"])
def home():
    return {"message": "Vehicle API is running. Visit /docs to test it."}


# Manufacturer endpoints
@app.post(
    "/manufacturers",
    response_model=Manufacturer,
    status_code=status.HTTP_201_CREATED,
    tags=["Manufacturers"],
)
def create_manufacturer(data: ManufacturerInput):
    manufacturer_id = next(manufacturer_ids)
    manufacturer = Manufacturer(
        id=manufacturer_id,
        **data.model_dump(),
    )
    manufacturers[manufacturer_id] = manufacturer
    return manufacturer


@app.get(
    "/manufacturers",
    response_model=list[Manufacturer],
    tags=["Manufacturers"],
)
def list_manufacturers():
    return list(manufacturers.values())


@app.get(
    "/manufacturers/{manufacturer_id}",
    response_model=Manufacturer,
    tags=["Manufacturers"],
)
def get_manufacturer(manufacturer_id: int):
    return find_manufacturer(manufacturer_id)


@app.put(
    "/manufacturers/{manufacturer_id}",
    response_model=Manufacturer,
    tags=["Manufacturers"],
)
def update_manufacturer(manufacturer_id: int, data: ManufacturerInput):
    find_manufacturer(manufacturer_id)
    manufacturer = Manufacturer(
        id=manufacturer_id,
        **data.model_dump(),
    )
    manufacturers[manufacturer_id] = manufacturer
    return manufacturer


@app.delete(
    "/manufacturers/{manufacturer_id}",
    status_code=status.HTTP_204_NO_CONTENT,
    tags=["Manufacturers"],
)
def delete_manufacturer(manufacturer_id: int):
    find_manufacturer(manufacturer_id)

    # Prevent vehicles from referencing a deleted manufacturer.
    if any(
        vehicle.manufacturer_id == manufacturer_id
        for vehicle in vehicles.values()
    ):
        raise HTTPException(
            status_code=409,
            detail="Delete this manufacturer's vehicles first",
        )

    del manufacturers[manufacturer_id]
    return Response(status_code=status.HTTP_204_NO_CONTENT)


@app.get(
    "/manufacturers/{manufacturer_id}/vehicles",
    response_model=list[Vehicle],
    tags=["Manufacturers"],
)
def list_vehicles_by_manufacturer(manufacturer_id: int):
    find_manufacturer(manufacturer_id)
    return [
        vehicle
        for vehicle in vehicles.values()
        if vehicle.manufacturer_id == manufacturer_id
    ]


# Vehicle endpoints
@app.post(
    "/vehicles",
    response_model=Vehicle,
    status_code=status.HTTP_201_CREATED,
    tags=["Vehicles"],
)
def create_vehicle(data: VehicleInput):
    find_manufacturer(data.manufacturer_id)
    vehicle_id = next(vehicle_ids)
    vehicle = Vehicle(id=vehicle_id, **data.model_dump())
    vehicles[vehicle_id] = vehicle
    return vehicle


@app.get(
    "/vehicles",
    response_model=list[Vehicle],
    tags=["Vehicles"],
)
def list_vehicles():
    return list(vehicles.values())


@app.get(
    "/vehicles/{vehicle_id}",
    response_model=Vehicle,
    tags=["Vehicles"],
)
def get_vehicle(vehicle_id: int):
    return find_vehicle(vehicle_id)


@app.put(
    "/vehicles/{vehicle_id}",
    response_model=Vehicle,
    tags=["Vehicles"],
)
def update_vehicle(vehicle_id: int, data: VehicleInput):
    find_vehicle(vehicle_id)
    find_manufacturer(data.manufacturer_id)
    vehicle = Vehicle(id=vehicle_id, **data.model_dump())
    vehicles[vehicle_id] = vehicle
    return vehicle


@app.delete(
    "/vehicles/{vehicle_id}",
    status_code=status.HTTP_204_NO_CONTENT,
    tags=["Vehicles"],
)
def delete_vehicle(vehicle_id: int):
    find_vehicle(vehicle_id)
    del vehicles[vehicle_id]
    return Response(status_code=status.HTTP_204_NO_CONTENT)