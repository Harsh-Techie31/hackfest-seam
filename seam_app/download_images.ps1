# Create directories if they don't exist
New-Item -ItemType Directory -Force -Path "assets\brands"
New-Item -ItemType Directory -Force -Path "assets\menu_items"

# Download brand logos
$brandLogos = @{
    "kfc.png" = "https://upload.wikimedia.org/wikipedia/commons/8/85/KFC_logo.svg"
    "mcdonald.jpg" = "https://upload.wikimedia.org/wikipedia/commons/3/36/McDonald%27s_Golden_Arches.svg"
    "burgerking.png" = "https://upload.wikimedia.org/wikipedia/commons/8/85/Burger_King_logo_%281999%29.svg"
    "pizzahut.png" = "https://upload.wikimedia.org/wikipedia/commons/d/d2/Pizza_Hut_2014_logo.svg"
    "subway.png" = "https://upload.wikimedia.org/wikipedia/commons/5/59/Subway_2016_logo.svg"
    "dominos.png" = "https://upload.wikimedia.org/wikipedia/commons/7/74/Dominos_pizza_logo.svg"
}

# Download menu item images
$menuItems = @{
    "kfc_burger.jpg" = "https://images.unsplash.com/photo-1568901346375-23c9450c58cd"
    "kfc_chicken.jpg" = "https://images.unsplash.com/photo-1626645738196-c2a7c87a8f58"
    "kfc_rice.jpg" = "https://images.unsplash.com/photo-1512058564366-18510be2db19"
    "mcd_burger.jpg" = "https://images.unsplash.com/photo-1561758033-d89a9ad46330"
    "mcd_chicken.jpg" = "https://images.unsplash.com/photo-1632558615868-515d5b5c3d00"
    "bk_burger.jpg" = "https://images.unsplash.com/photo-1586190848861-99aa4a171e90"
    "bk_fries.jpg" = "https://images.unsplash.com/photo-1630384066958-6132f9b7b0d5"
    "ph_pizza.jpg" = "https://images.unsplash.com/photo-1513104890138-7c749659a591"
    "ph_pepperoni.jpg" = "https://images.unsplash.com/photo-1628840042765-356cda07504e"
    "sub_veggie.jpg" = "https://images.unsplash.com/photo-1626700051175-6818013e1d4f"
    "sub_chicken.jpg" = "https://images.unsplash.com/photo-1632558615868-515d5b5c3d00"
    "dom_pizza.jpg" = "https://images.unsplash.com/photo-1513104890138-7c749659a591"
    "dom_chicken.jpg" = "https://images.unsplash.com/photo-1626645738196-c2a7c87a8f58"
}

# Download brand logos
foreach ($logo in $brandLogos.GetEnumerator()) {
    $outputPath = "assets\brands\$($logo.Key)"
    Write-Host "Downloading $($logo.Key)..."
    Invoke-WebRequest -Uri $logo.Value -OutFile $outputPath
}

# Download menu items
foreach ($item in $menuItems.GetEnumerator()) {
    $outputPath = "assets\menu_items\$($item.Key)"
    Write-Host "Downloading $($item.Key)..."
    Invoke-WebRequest -Uri $item.Value -OutFile $outputPath
}

Write-Host "All images downloaded successfully!" 