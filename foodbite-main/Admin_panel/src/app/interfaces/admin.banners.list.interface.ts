

export interface AdminBannersListInterface {
  title: string
  type: string
  city: City
  restaurant: string
  food: string
  external: string
  image: string
  translations: Translation2[]
  status: boolean
  id: string
  displayName: string
}

export interface City {
  id: string
  name: string
  translations: Translation[]
  displayName: string
}

export interface Translation {
  name: string
  code: string
  nativeName: string
  value: string
}

export interface Translation2 {
  name: string
  code: string
  nativeName: string
  value: string
}

