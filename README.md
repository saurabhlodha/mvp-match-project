# Vending Machine
## API's

##### Sign Up

URL - `POST http://localhost:3000/api/v1/users`

##### Request

```ruby
{
    "user": {
        "name": "Tom Hardy",
        "email": "tommy@test.com",
        "password": "Password123@"
    }
}
```

##### Response

```ruby
{
    "status": "User created successfully",
    "user": {
        "id": 6,
        "email": "tommy@test.com",
        "password_digest": "$2a$12$E4TiU1Qc7l4gnC3g3IfpHuXvI.8AnH9n4GSWwFtUHUU1GSFKKZun6",
        "name": "Tom Hardy",
        "created_at": "2022-01-18T15:22:08.049Z",
        "updated_at": "2022-01-18T15:22:08.049Z",
        "deposit": 0,
        "role": "buyer"
    }
}
```

##### Sign in

URL - `GET http://localhost:3000/api/v1/users`

##### Request

```ruby
{
    "email": "tommy@test.com",
    "password": "Password123@"
}
```

##### Response

```ruby
{
    "auth_token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo1fQ.vMMFXkseg44Smpos_DF70TYWp4honJYTLfXBrOOl1nM",
    "user": {
        "id": 5,
        "email": "tommy@test.com",
        "password_digest": "$2a$12$hfc6qq3CJeyAl2K6f2Vem.VoxFybcaKjlIgjw5CaKS3jOy9elMjTe",
        "name": "Tom Hardy",
        "created_at": "2022-01-18T15:09:15.037Z",
        "updated_at": "2022-01-18T15:09:15.037Z",
        "deposit": 0,
        "role": "buyer"
    }
}
```

##### Product create

URL - `POST http://localhost:3000/api/v1/products`

##### Request

```ruby
{
    "product": {
        "product_name": "Water Bottle",
        "cost": 5,
        "amount_available": 10
    }
}
```

##### Response

```ruby
{
    "id": 1,
    "amount_available": 10,
    "cost": 5,
    "product_name": "Water Bottle",
    "seller_id": 1,
    "created_at": "2022-01-18T15:27:27.946Z",
    "updated_at": "2022-01-18T15:27:27.946Z"
}
```

##### Product Update

URL - `PUT http://localhost:3000/api/v1/products/1`

##### Request

```ruby
{
    "product": {
        "product_name": "Water Bottle",
        "cost": 15,
        "amount_available": 120
    }
}
```

##### Response

```ruby
{
    "amount_available": 120,
    "cost": 15,
    "product_name": "Water Bottle",
    "id": 1,
    "seller_id": 1,
    "created_at": "2022-01-18T10:47:37.721Z",
    "updated_at": "2022-01-18T15:29:10.296Z"
}
```

##### Product Delete

URL - `DELETE http://localhost:3000/api/v1/products/1`

##### Product List

URL - `GET http://localhost:3000/api/v1/products`

##### Response

```ruby
[
    {
        "id": 3,
        "amount_available": 19,
        "cost": 15,
        "product_name": "Coco Cola",
        "seller_id": 3,
        "created_at": "2022-01-18T10:47:37.726Z",
        "updated_at": "2022-01-18T10:47:37.726Z"
    },
    {
        "id": 4,
        "amount_available": 8,
        "cost": 10,
        "product_name": "Pepsi",
        "seller_id": 3,
        "created_at": "2022-01-18T10:47:37.731Z",
        "updated_at": "2022-01-18T10:47:37.731Z"
    }
]
```

##### User Deposit

URL - `POST http://localhost:3000/api/v1/users/deposit`

##### Request

```ruby
{
    "amount": 100
}
```

##### Response

```ruby
{
    "status": "Amount deposited successfully",
    "user": {
        "id": 2,
        "email": "buyer2@example.com",
        "password_digest": "$2a$12$urcUQZk5gaJpWBJgk77rxedSCOsVEA9AnBTMD/g/XmWYXqKw2PMN2",
        "name": "Jane Doe",
        "created_at": "2022-01-18T10:47:37.298Z",
        "updated_at": "2022-01-18T15:32:46.422Z",
        "deposit": 290,
        "role": "buyer"
    }
}
```

##### Buy Product

URL - `POST http://localhost:3000/api/v1/products/1/buy`

##### Request

```ruby
{
    "amount": 2
}
```

##### Response

```ruby
{
    "total_spent": 0,
    "product": {
        "amount_available": 19,
        "id": 3,
        "cost": 15,
        "product_name": "Coco Cola",
        "seller_id": 3,
        "created_at": "2022-01-18T10:47:37.726Z",
        "updated_at": "2022-01-18T10:47:37.726Z"
    },
    "balance_left": [1,0,1,0,0]
}
```

