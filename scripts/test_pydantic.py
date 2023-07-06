from pydantic import BaseModel
from typing import Dict

class MyData(BaseModel):
    field1: int
    field2: str
    field3: Dict[str, int]

    def add_field3(self, key, val):
        self.field3[key] = val

if __name__ == "__main__":
    dt = MyData(field1=10, field2="test", field3 = {})
    dt.add_field3("zhangjiang", 1)
    dt.add_field3("xuhui", 2)
    json_str = dt.json()
    print(json_str)
