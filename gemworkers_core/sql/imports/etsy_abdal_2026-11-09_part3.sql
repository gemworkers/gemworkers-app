-- Abdal Shop Etsy import, PART 3 of 3 (248 drafts, unlisted; USD→EUR at ECB 1.1193). Run parts in order. Safe to run twice.
BEGIN;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('2f903db3-8397-4f0f-8d80-4bec81759b46', '2.75 Cts Tricolour Tourmaline', 'Natural bicolour mesmerising tourmaline 

2.75 Cts
14 x 5.2 x 3.7mm

unheated,', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 2.75, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/2f903db3-8397-4f0f-8d80-4bec81759b46/etsy-1.jpg","https://media.gemworkers.com/items/2f903db3-8397-4f0f-8d80-4bec81759b46/etsy-2.jpg","https://media.gemworkers.com/items/2f903db3-8397-4f0f-8d80-4bec81759b46/etsy-3.jpg","https://media.gemworkers.com/items/2f903db3-8397-4f0f-8d80-4bec81759b46/etsy-4.jpg","https://media.gemworkers.com/items/2f903db3-8397-4f0f-8d80-4bec81759b46/etsy-5.jpg","https://media.gemworkers.com/items/2f903db3-8397-4f0f-8d80-4bec81759b46/etsy-6.jpg","https://media.gemworkers.com/items/2f903db3-8397-4f0f-8d80-4bec81759b46/etsy-7.jpg","https://media.gemworkers.com/items/2f903db3-8397-4f0f-8d80-4bec81759b46/etsy-8.jpg","https://media.gemworkers.com/items/2f903db3-8397-4f0f-8d80-4bec81759b46/etsy-9.jpg","https://media.gemworkers.com/items/2f903db3-8397-4f0f-8d80-4bec81759b46/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Rings for women,natural stone,gift for her,jewellery making,jewellery supplies,jewellery findings,bicolour tourmaline,pink tourmaline,stud jewellery,tourmaline emerald,emerald cut,green tourmaline,Watermelon Tourmalin.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('569f22b8-6878-4619-a43b-05ec36dab30b', '1.65 Cts Bicolour Tourmaline', 'Natural bicolour mesmerising tourmaline 

1.65 Cts
12 x 3.9 x 3.2mm

unheated,', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 134, 1, 'loose_stone', 'Tourmaline', NULL, 1.65, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/569f22b8-6878-4619-a43b-05ec36dab30b/etsy-1.jpg","https://media.gemworkers.com/items/569f22b8-6878-4619-a43b-05ec36dab30b/etsy-2.jpg","https://media.gemworkers.com/items/569f22b8-6878-4619-a43b-05ec36dab30b/etsy-3.jpg","https://media.gemworkers.com/items/569f22b8-6878-4619-a43b-05ec36dab30b/etsy-4.jpg","https://media.gemworkers.com/items/569f22b8-6878-4619-a43b-05ec36dab30b/etsy-5.jpg","https://media.gemworkers.com/items/569f22b8-6878-4619-a43b-05ec36dab30b/etsy-6.jpg","https://media.gemworkers.com/items/569f22b8-6878-4619-a43b-05ec36dab30b/etsy-7.jpg","https://media.gemworkers.com/items/569f22b8-6878-4619-a43b-05ec36dab30b/etsy-8.jpg","https://media.gemworkers.com/items/569f22b8-6878-4619-a43b-05ec36dab30b/etsy-9.jpg","https://media.gemworkers.com/items/569f22b8-6878-4619-a43b-05ec36dab30b/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 150 USD, converted at ECB rate. Etsy tags: Rings for women,rings for men,natural stone,gift for her,jewellery making,jewellery supplies,jewellery findings,bicolour tourmaline,pink tourmaline,stud jewellery,tourmaline emerald,emerald cut,green tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('0033432b-c943-469e-8ff8-fdcb653d5934', '1.5 Cts Neon Pink Spinel From Burma', 'A Very Unique Spinel 

Purplish Pink Colour

Bright And Brilliance 

1.50 Cts
7.4 x 5.9 x 3.7mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Spinel', NULL, 1.5, 'ct', 'Myanmar', NULL, NULL, '["https://media.gemworkers.com/items/0033432b-c943-469e-8ff8-fdcb653d5934/etsy-1.jpg","https://media.gemworkers.com/items/0033432b-c943-469e-8ff8-fdcb653d5934/etsy-2.jpg","https://media.gemworkers.com/items/0033432b-c943-469e-8ff8-fdcb653d5934/etsy-3.jpg","https://media.gemworkers.com/items/0033432b-c943-469e-8ff8-fdcb653d5934/etsy-4.jpg","https://media.gemworkers.com/items/0033432b-c943-469e-8ff8-fdcb653d5934/etsy-5.jpg","https://media.gemworkers.com/items/0033432b-c943-469e-8ff8-fdcb653d5934/etsy-6.jpg","https://media.gemworkers.com/items/0033432b-c943-469e-8ff8-fdcb653d5934/etsy-7.jpg","https://media.gemworkers.com/items/0033432b-c943-469e-8ff8-fdcb653d5934/etsy-8.jpg","https://media.gemworkers.com/items/0033432b-c943-469e-8ff8-fdcb653d5934/etsy-9.jpg","https://media.gemworkers.com/items/0033432b-c943-469e-8ff8-fdcb653d5934/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Spinel Jewellery,Spinel Rings,Pink Spinel,Orange Spinel,Bicolour Spinel,Unique Spinel,Faceted Spinel,Jewellery Making,Jewellery Supplies,Oceangemsminerals,Spinel Necklace,Gift For Her,Natural Stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('99d51e2c-5dfc-4ecd-ad60-52ea8537f8b5', '1.4 Cts Neon Pink Spinel From Burma', 'A Very Unique Spinel 

Purplish Pink Colour

Bright And Brilliance 

1.40 Cts
8.2 x 5.4 x 4.4mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 250, 1, 'loose_stone', 'Spinel', NULL, 1.4, 'ct', 'Myanmar', NULL, NULL, '["https://media.gemworkers.com/items/99d51e2c-5dfc-4ecd-ad60-52ea8537f8b5/etsy-1.jpg","https://media.gemworkers.com/items/99d51e2c-5dfc-4ecd-ad60-52ea8537f8b5/etsy-2.jpg","https://media.gemworkers.com/items/99d51e2c-5dfc-4ecd-ad60-52ea8537f8b5/etsy-3.jpg","https://media.gemworkers.com/items/99d51e2c-5dfc-4ecd-ad60-52ea8537f8b5/etsy-4.jpg","https://media.gemworkers.com/items/99d51e2c-5dfc-4ecd-ad60-52ea8537f8b5/etsy-5.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 280 USD, converted at ECB rate. Etsy tags: Spinel Jewellery,Spinel Rings,Pink Spinel,Orange Spinel,Bicolour Spinel,Unique Spinel,Faceted Spinel,Jewellery Making,Jewellery Supplies,Oceangemsminerals,Spinel Necklace,Gift For Her,Natural Stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('76f38709-6530-4b08-8416-e45429e7e3be', '2.1 Cts Pinkish Purple Spinel', 'A Very Unique Spinel 

Purplish Pink Colour

Bright And Brilliance 

2.1 Cts
7.5 x 5.8 x 5.2mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 214, 1, 'loose_stone', 'Spinel', NULL, 2.1, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/76f38709-6530-4b08-8416-e45429e7e3be/etsy-1.jpg","https://media.gemworkers.com/items/76f38709-6530-4b08-8416-e45429e7e3be/etsy-2.jpg","https://media.gemworkers.com/items/76f38709-6530-4b08-8416-e45429e7e3be/etsy-3.jpg","https://media.gemworkers.com/items/76f38709-6530-4b08-8416-e45429e7e3be/etsy-4.jpg","https://media.gemworkers.com/items/76f38709-6530-4b08-8416-e45429e7e3be/etsy-5.jpg","https://media.gemworkers.com/items/76f38709-6530-4b08-8416-e45429e7e3be/etsy-6.jpg","https://media.gemworkers.com/items/76f38709-6530-4b08-8416-e45429e7e3be/etsy-7.jpg","https://media.gemworkers.com/items/76f38709-6530-4b08-8416-e45429e7e3be/etsy-8.jpg","https://media.gemworkers.com/items/76f38709-6530-4b08-8416-e45429e7e3be/etsy-9.jpg","https://media.gemworkers.com/items/76f38709-6530-4b08-8416-e45429e7e3be/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 240 USD, converted at ECB rate. Etsy tags: Spinel Jewellery,Spinel Rings,Pink Spinel,Orange Spinel,Bicolour Spinel,Unique Spinel,Faceted Spinel,Jewellery Making,Jewellery Supplies,Oceangemsminerals,Spinel Necklace,Gift For Her,Natural Stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('d8f0d98a-84b6-410c-9659-0891af07b7a0', '1.2 Cts Pinkish Purple Spinel', 'A Very Unique Spinel 

Purplish Pink Colour

Bright And Brilliance 

1.20 Cts
6.2 x 6.2 x 4mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 214, 1, 'loose_stone', 'Spinel', NULL, 1.2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/d8f0d98a-84b6-410c-9659-0891af07b7a0/etsy-1.jpg","https://media.gemworkers.com/items/d8f0d98a-84b6-410c-9659-0891af07b7a0/etsy-2.jpg","https://media.gemworkers.com/items/d8f0d98a-84b6-410c-9659-0891af07b7a0/etsy-3.jpg","https://media.gemworkers.com/items/d8f0d98a-84b6-410c-9659-0891af07b7a0/etsy-4.jpg","https://media.gemworkers.com/items/d8f0d98a-84b6-410c-9659-0891af07b7a0/etsy-5.jpg","https://media.gemworkers.com/items/d8f0d98a-84b6-410c-9659-0891af07b7a0/etsy-6.jpg","https://media.gemworkers.com/items/d8f0d98a-84b6-410c-9659-0891af07b7a0/etsy-7.jpg","https://media.gemworkers.com/items/d8f0d98a-84b6-410c-9659-0891af07b7a0/etsy-8.jpg","https://media.gemworkers.com/items/d8f0d98a-84b6-410c-9659-0891af07b7a0/etsy-9.jpg","https://media.gemworkers.com/items/d8f0d98a-84b6-410c-9659-0891af07b7a0/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 240 USD, converted at ECB rate. Etsy tags: Spinel Jewellery,Spinel Rings,Pink Spinel,Orange Spinel,Bicolour Spinel,Unique Spinel,Faceted Spinel,Jewellery Making,Jewellery Supplies,Oceangemsminerals,Spinel Necklace,Gift For Her,Natural Stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('81e39f49-b3d7-455f-9ac3-7934d567941f', '1.4 Cts Pinkish Purple Spinel', 'A Very Unique Spinel 

Purplish Pink Colour

Bright And Brilliance 

1.40 Cts
7.6 x 5.1 x 4mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 250, 1, 'loose_stone', 'Spinel', NULL, 1.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/81e39f49-b3d7-455f-9ac3-7934d567941f/etsy-1.jpg","https://media.gemworkers.com/items/81e39f49-b3d7-455f-9ac3-7934d567941f/etsy-2.jpg","https://media.gemworkers.com/items/81e39f49-b3d7-455f-9ac3-7934d567941f/etsy-3.jpg","https://media.gemworkers.com/items/81e39f49-b3d7-455f-9ac3-7934d567941f/etsy-4.jpg","https://media.gemworkers.com/items/81e39f49-b3d7-455f-9ac3-7934d567941f/etsy-5.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 280 USD, converted at ECB rate. Etsy tags: Spinel Jewellery,Spinel Rings,Pink Spinel,Orange Spinel,Bicolour Spinel,Unique Spinel,Faceted Spinel,Jewellery Making,Jewellery Supplies,Oceangemsminerals,Spinel Necklace,Gift For Her,Natural Stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('67fb8fe3-4bc9-4eec-be9c-9ff92db776ca', '1.5 Cts Pinkish Purple Spinel', 'A Very Unique Spinel 

Purplish Pink Colour

Bright And Brilliance 

1.50 Cts
8.3 x 5.1 x 3.6mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Spinel', NULL, 1.5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/67fb8fe3-4bc9-4eec-be9c-9ff92db776ca/etsy-1.jpg","https://media.gemworkers.com/items/67fb8fe3-4bc9-4eec-be9c-9ff92db776ca/etsy-2.jpg","https://media.gemworkers.com/items/67fb8fe3-4bc9-4eec-be9c-9ff92db776ca/etsy-3.jpg","https://media.gemworkers.com/items/67fb8fe3-4bc9-4eec-be9c-9ff92db776ca/etsy-4.jpg","https://media.gemworkers.com/items/67fb8fe3-4bc9-4eec-be9c-9ff92db776ca/etsy-5.jpg","https://media.gemworkers.com/items/67fb8fe3-4bc9-4eec-be9c-9ff92db776ca/etsy-6.jpg","https://media.gemworkers.com/items/67fb8fe3-4bc9-4eec-be9c-9ff92db776ca/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Spinel Jewellery,Spinel Rings,Pink Spinel,Orange Spinel,Bicolour Spinel,Unique Spinel,Faceted Spinel,Jewellery Making,Jewellery Supplies,Oceangemsminerals,Spinel Necklace,Gift For Her,Natural Stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('ae45b451-de11-44c1-ab0a-1a7e1b8a33b5', '2.50 Cts Yellow Tourmaline Pairs', 'yellow tourmaline Earring Set

Ethically Sourced 

2.50 Cts
5.8 x 4 x 3.2mm
5.1 x 4.7 x 3.8mm

Unheated,Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 134, 1, 'loose_stone', 'Tourmaline', NULL, 2.5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/ae45b451-de11-44c1-ab0a-1a7e1b8a33b5/etsy-1.jpg","https://media.gemworkers.com/items/ae45b451-de11-44c1-ab0a-1a7e1b8a33b5/etsy-2.jpg","https://media.gemworkers.com/items/ae45b451-de11-44c1-ab0a-1a7e1b8a33b5/etsy-3.jpg","https://media.gemworkers.com/items/ae45b451-de11-44c1-ab0a-1a7e1b8a33b5/etsy-4.jpg","https://media.gemworkers.com/items/ae45b451-de11-44c1-ab0a-1a7e1b8a33b5/etsy-5.jpg","https://media.gemworkers.com/items/ae45b451-de11-44c1-ab0a-1a7e1b8a33b5/etsy-6.jpg","https://media.gemworkers.com/items/ae45b451-de11-44c1-ab0a-1a7e1b8a33b5/etsy-7.jpg","https://media.gemworkers.com/items/ae45b451-de11-44c1-ab0a-1a7e1b8a33b5/etsy-8.jpg","https://media.gemworkers.com/items/ae45b451-de11-44c1-ab0a-1a7e1b8a33b5/etsy-9.jpg","https://media.gemworkers.com/items/ae45b451-de11-44c1-ab0a-1a7e1b8a33b5/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 150 USD, converted at ECB rate. Etsy tags: jewellery,tourmaline pair,earrings,tourmaline jewellery,bicolour tourmaline,y2k earrings stud,Jewellery Making,Jewellery Findings,Jewellery Supplies,Natural Stone,Tourmaline Earrings,Loose Gemstones,Yellow Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('c1c6fd94-cf1e-46ed-ba81-d42a12480db7', '9.85 Cts Green Blue Tourmaline Lot', 'lagoon and neon blue colour tourmaline Lot

top colour high lustre and brilliance 

9.85 Cts
8.9 to 6mm

100% natural no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 9.85, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/c1c6fd94-cf1e-46ed-ba81-d42a12480db7/etsy-1.jpg","https://media.gemworkers.com/items/c1c6fd94-cf1e-46ed-ba81-d42a12480db7/etsy-2.jpg","https://media.gemworkers.com/items/c1c6fd94-cf1e-46ed-ba81-d42a12480db7/etsy-3.jpg","https://media.gemworkers.com/items/c1c6fd94-cf1e-46ed-ba81-d42a12480db7/etsy-4.jpg","https://media.gemworkers.com/items/c1c6fd94-cf1e-46ed-ba81-d42a12480db7/etsy-5.jpg","https://media.gemworkers.com/items/c1c6fd94-cf1e-46ed-ba81-d42a12480db7/etsy-6.jpg","https://media.gemworkers.com/items/c1c6fd94-cf1e-46ed-ba81-d42a12480db7/etsy-7.jpg","https://media.gemworkers.com/items/c1c6fd94-cf1e-46ed-ba81-d42a12480db7/etsy-8.jpg","https://media.gemworkers.com/items/c1c6fd94-cf1e-46ed-ba81-d42a12480db7/etsy-9.jpg","https://media.gemworkers.com/items/c1c6fd94-cf1e-46ed-ba81-d42a12480db7/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Natural Stone,Jewellery Supplies,Jewellery Making,Jewellery Findings,y2k stud earrings,Gift For Her,Rings For Men,Rings For Women,Gold Rings,Silver Sterling,Garnet Necklace,Garnet Rings,Garnet Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('888c1b0e-ab0f-451c-9f06-fabbde1ff1d7', '3.2 Cts Rubilite Tourmaline', 'Gorgeous Rubilite Tourmaline best for ring 💍 

3.20 Cts
14.1 x 7.9 x 5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 536, 1, 'loose_stone', 'Tourmaline', 'Rubellite', 3.2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/888c1b0e-ab0f-451c-9f06-fabbde1ff1d7/etsy-1.jpg","https://media.gemworkers.com/items/888c1b0e-ab0f-451c-9f06-fabbde1ff1d7/etsy-2.jpg","https://media.gemworkers.com/items/888c1b0e-ab0f-451c-9f06-fabbde1ff1d7/etsy-3.jpg","https://media.gemworkers.com/items/888c1b0e-ab0f-451c-9f06-fabbde1ff1d7/etsy-4.jpg","https://media.gemworkers.com/items/888c1b0e-ab0f-451c-9f06-fabbde1ff1d7/etsy-5.jpg","https://media.gemworkers.com/items/888c1b0e-ab0f-451c-9f06-fabbde1ff1d7/etsy-6.jpg","https://media.gemworkers.com/items/888c1b0e-ab0f-451c-9f06-fabbde1ff1d7/etsy-7.jpg","https://media.gemworkers.com/items/888c1b0e-ab0f-451c-9f06-fabbde1ff1d7/etsy-8.jpg","https://media.gemworkers.com/items/888c1b0e-ab0f-451c-9f06-fabbde1ff1d7/etsy-9.jpg","https://media.gemworkers.com/items/888c1b0e-ab0f-451c-9f06-fabbde1ff1d7/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 600 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('032f4c72-0ac9-4b0a-ba14-094ecbc4ad2d', '1.4 Cts Rubilite Tourmaline', 'Gorgeous Rubilite Tourmaline best for ring 💍 

1.40 Cts
8.4 x 6.5 x 4.5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', 'Rubellite', 1.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/032f4c72-0ac9-4b0a-ba14-094ecbc4ad2d/etsy-1.jpg","https://media.gemworkers.com/items/032f4c72-0ac9-4b0a-ba14-094ecbc4ad2d/etsy-2.jpg","https://media.gemworkers.com/items/032f4c72-0ac9-4b0a-ba14-094ecbc4ad2d/etsy-3.jpg","https://media.gemworkers.com/items/032f4c72-0ac9-4b0a-ba14-094ecbc4ad2d/etsy-4.jpg","https://media.gemworkers.com/items/032f4c72-0ac9-4b0a-ba14-094ecbc4ad2d/etsy-5.jpg","https://media.gemworkers.com/items/032f4c72-0ac9-4b0a-ba14-094ecbc4ad2d/etsy-6.jpg","https://media.gemworkers.com/items/032f4c72-0ac9-4b0a-ba14-094ecbc4ad2d/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('b7d1ac1b-cdc4-4d3a-a514-799be12b11a7', '5.55 Cts Neon Blue Tourmaline Lot', 'lagoon and neon blue colour tourmaline Lot

top colour high lustre and brilliance 

5.55 Cts
5.4 to 4.1mm

100% natural no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 356, 1, 'loose_stone', 'Tourmaline', NULL, 5.55, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/b7d1ac1b-cdc4-4d3a-a514-799be12b11a7/etsy-1.jpg","https://media.gemworkers.com/items/b7d1ac1b-cdc4-4d3a-a514-799be12b11a7/etsy-2.jpg","https://media.gemworkers.com/items/b7d1ac1b-cdc4-4d3a-a514-799be12b11a7/etsy-3.jpg","https://media.gemworkers.com/items/b7d1ac1b-cdc4-4d3a-a514-799be12b11a7/etsy-4.jpg","https://media.gemworkers.com/items/b7d1ac1b-cdc4-4d3a-a514-799be12b11a7/etsy-5.jpg","https://media.gemworkers.com/items/b7d1ac1b-cdc4-4d3a-a514-799be12b11a7/etsy-6.jpg","https://media.gemworkers.com/items/b7d1ac1b-cdc4-4d3a-a514-799be12b11a7/etsy-7.jpg","https://media.gemworkers.com/items/b7d1ac1b-cdc4-4d3a-a514-799be12b11a7/etsy-8.jpg","https://media.gemworkers.com/items/b7d1ac1b-cdc4-4d3a-a514-799be12b11a7/etsy-9.jpg","https://media.gemworkers.com/items/b7d1ac1b-cdc4-4d3a-a514-799be12b11a7/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 399 USD, converted at ECB rate. Etsy tags: Natural Stone,Jewellery Supplies,Jewellery Making,Jewellery Findings,y2k stud earrings,Gift For Her,Rings For Men,Rings For Women,Gold Rings,Silver Sterling,Garnet Necklace,Garnet Rings,Garnet Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('c8cd106b-8b6e-41f1-8a8f-c300ea1968c8', '1.1 Cts Neon Blue Tourmaline', 'lagoon and neon blue colour tourmaline

top colour high lustre and brilliance 

Paraiba Like Colour

1.10 Cts
6 x 6 x 4.8mm

100% natural no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 447, 1, 'loose_stone', 'Tourmaline', NULL, 1.1, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/c8cd106b-8b6e-41f1-8a8f-c300ea1968c8/etsy-1.jpg","https://media.gemworkers.com/items/c8cd106b-8b6e-41f1-8a8f-c300ea1968c8/etsy-2.jpg","https://media.gemworkers.com/items/c8cd106b-8b6e-41f1-8a8f-c300ea1968c8/etsy-3.jpg","https://media.gemworkers.com/items/c8cd106b-8b6e-41f1-8a8f-c300ea1968c8/etsy-4.jpg","https://media.gemworkers.com/items/c8cd106b-8b6e-41f1-8a8f-c300ea1968c8/etsy-5.jpg","https://media.gemworkers.com/items/c8cd106b-8b6e-41f1-8a8f-c300ea1968c8/etsy-6.jpg","https://media.gemworkers.com/items/c8cd106b-8b6e-41f1-8a8f-c300ea1968c8/etsy-7.jpg","https://media.gemworkers.com/items/c8cd106b-8b6e-41f1-8a8f-c300ea1968c8/etsy-8.jpg","https://media.gemworkers.com/items/c8cd106b-8b6e-41f1-8a8f-c300ea1968c8/etsy-9.jpg","https://media.gemworkers.com/items/c8cd106b-8b6e-41f1-8a8f-c300ea1968c8/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 500 USD, converted at ECB rate. Etsy tags: Natural Stone,Jewellery Supplies,Jewellery Making,Jewellery Findings,y2k stud earrings,Gift For Her,Rings For Men,Rings For Women,Gold Rings,Silver Sterling,Garnet Necklace,Garnet Rings,Garnet Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('8c3fcb48-2477-4a81-9698-aa9217ea3d9c', '6.20 Cts Tricolour Tourmaline Pairs', 'To All The Bicolour Lovers Here Is An Incredible Opportunity Buy A Truly Exceptional And One Of A Kind Tricolour Tourmaline Pairs 

Purple, Pink, And Apple Green Combination 

6.20 Cts
8.6 x 5.5 x 3.6mm
8.1 x 5 x 3.4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 429, 1, 'loose_stone', 'Tourmaline', NULL, 6.2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/8c3fcb48-2477-4a81-9698-aa9217ea3d9c/etsy-1.jpg","https://media.gemworkers.com/items/8c3fcb48-2477-4a81-9698-aa9217ea3d9c/etsy-2.jpg","https://media.gemworkers.com/items/8c3fcb48-2477-4a81-9698-aa9217ea3d9c/etsy-3.jpg","https://media.gemworkers.com/items/8c3fcb48-2477-4a81-9698-aa9217ea3d9c/etsy-4.jpg","https://media.gemworkers.com/items/8c3fcb48-2477-4a81-9698-aa9217ea3d9c/etsy-5.jpg","https://media.gemworkers.com/items/8c3fcb48-2477-4a81-9698-aa9217ea3d9c/etsy-6.jpg","https://media.gemworkers.com/items/8c3fcb48-2477-4a81-9698-aa9217ea3d9c/etsy-7.jpg","https://media.gemworkers.com/items/8c3fcb48-2477-4a81-9698-aa9217ea3d9c/etsy-8.jpg","https://media.gemworkers.com/items/8c3fcb48-2477-4a81-9698-aa9217ea3d9c/etsy-9.jpg","https://media.gemworkers.com/items/8c3fcb48-2477-4a81-9698-aa9217ea3d9c/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 480 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,jewels,Handmadejewellery,gift for her,Topqualitytourmaline,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('e2b95fca-066f-47a6-8fa6-fcbf87a9c438', '5.95 Cts Tricolour Tourmaline Pairs', 'To All The Bicolour Lovers Here Is An Incredible Opportunity Buy A Truly Exceptional And One Of A Kind Tricolour Tourmaline Pairs 

Purple, Pink, And Apple Green Combination 

5.95 Cts
9 x 5.3 x 3.9mm
8.8 x 4.5 x 2.9mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 402, 1, 'loose_stone', 'Tourmaline', NULL, 5.95, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/e2b95fca-066f-47a6-8fa6-fcbf87a9c438/etsy-1.jpg","https://media.gemworkers.com/items/e2b95fca-066f-47a6-8fa6-fcbf87a9c438/etsy-2.jpg","https://media.gemworkers.com/items/e2b95fca-066f-47a6-8fa6-fcbf87a9c438/etsy-3.jpg","https://media.gemworkers.com/items/e2b95fca-066f-47a6-8fa6-fcbf87a9c438/etsy-4.jpg","https://media.gemworkers.com/items/e2b95fca-066f-47a6-8fa6-fcbf87a9c438/etsy-5.jpg","https://media.gemworkers.com/items/e2b95fca-066f-47a6-8fa6-fcbf87a9c438/etsy-6.jpg","https://media.gemworkers.com/items/e2b95fca-066f-47a6-8fa6-fcbf87a9c438/etsy-7.jpg","https://media.gemworkers.com/items/e2b95fca-066f-47a6-8fa6-fcbf87a9c438/etsy-8.jpg","https://media.gemworkers.com/items/e2b95fca-066f-47a6-8fa6-fcbf87a9c438/etsy-9.jpg","https://media.gemworkers.com/items/e2b95fca-066f-47a6-8fa6-fcbf87a9c438/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 450 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,jewels,Handmadejewellery,gift for her,Topqualitytourmaline,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('438ceabd-133a-4b6c-813a-e470715c379e', '18.55 Cts Tricolour Tourmaline Pairs', 'To All The Bicolour Lovers Here Is An Incredible Opportunity Buy A Truly Exceptional And One Of A Kind Tricolour Tourmaline Pairs 

Purple, Pink, And Apple Green Combination 

18.55 Cts
9 x 7.6 x 5.2mm
9.4 x 6.6 x 5mm
8.8 x 6.3 x 4.9mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 715, 1, 'loose_stone', 'Tourmaline', NULL, 18.55, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/438ceabd-133a-4b6c-813a-e470715c379e/etsy-1.jpg","https://media.gemworkers.com/items/438ceabd-133a-4b6c-813a-e470715c379e/etsy-2.jpg","https://media.gemworkers.com/items/438ceabd-133a-4b6c-813a-e470715c379e/etsy-3.jpg","https://media.gemworkers.com/items/438ceabd-133a-4b6c-813a-e470715c379e/etsy-4.jpg","https://media.gemworkers.com/items/438ceabd-133a-4b6c-813a-e470715c379e/etsy-5.jpg","https://media.gemworkers.com/items/438ceabd-133a-4b6c-813a-e470715c379e/etsy-6.jpg","https://media.gemworkers.com/items/438ceabd-133a-4b6c-813a-e470715c379e/etsy-7.jpg","https://media.gemworkers.com/items/438ceabd-133a-4b6c-813a-e470715c379e/etsy-8.jpg","https://media.gemworkers.com/items/438ceabd-133a-4b6c-813a-e470715c379e/etsy-9.jpg","https://media.gemworkers.com/items/438ceabd-133a-4b6c-813a-e470715c379e/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 800 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,jewels,Handmadejewellery,gift for her,Topqualitytourmaline,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('de5764d0-eb0b-40ed-9448-9425e6cad560', '9.40 Cts Tricolour Tourmaline Pairs', 'To All The Bicolour Lovers Here Is An Incredible Opportunity Buy A Truly Exceptional And One Of A Kind Tricolour Tourmaline Pairs 

Purple, Pink, And Apple Green Combination 

9.40 Cts
9.1 x 6.5 x 5mm
9.2 x 4.9 x 3.5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 491, 1, 'loose_stone', 'Tourmaline', NULL, 9.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/de5764d0-eb0b-40ed-9448-9425e6cad560/etsy-1.jpg","https://media.gemworkers.com/items/de5764d0-eb0b-40ed-9448-9425e6cad560/etsy-2.jpg","https://media.gemworkers.com/items/de5764d0-eb0b-40ed-9448-9425e6cad560/etsy-3.jpg","https://media.gemworkers.com/items/de5764d0-eb0b-40ed-9448-9425e6cad560/etsy-4.jpg","https://media.gemworkers.com/items/de5764d0-eb0b-40ed-9448-9425e6cad560/etsy-5.jpg","https://media.gemworkers.com/items/de5764d0-eb0b-40ed-9448-9425e6cad560/etsy-6.jpg","https://media.gemworkers.com/items/de5764d0-eb0b-40ed-9448-9425e6cad560/etsy-7.jpg","https://media.gemworkers.com/items/de5764d0-eb0b-40ed-9448-9425e6cad560/etsy-8.jpg","https://media.gemworkers.com/items/de5764d0-eb0b-40ed-9448-9425e6cad560/etsy-9.jpg","https://media.gemworkers.com/items/de5764d0-eb0b-40ed-9448-9425e6cad560/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 550 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,jewels,Handmadejewellery,gift for her,Topqualitytourmaline,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('d4d6e835-f47e-460f-9e00-95ee3bc6acfa', '1.4 Cts Lagoon Tourmaline Pairs', 'Gorgeous Mesmerising Lagoon Blue Colour Afghan Tourmaline Pairs

Lustre and brilliance 

1.40 Cts
6 x 3.4 x 2.7mm
4.5 x 3.3 x 2.7mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 1.4, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/d4d6e835-f47e-460f-9e00-95ee3bc6acfa/etsy-1.jpg","https://media.gemworkers.com/items/d4d6e835-f47e-460f-9e00-95ee3bc6acfa/etsy-2.jpg","https://media.gemworkers.com/items/d4d6e835-f47e-460f-9e00-95ee3bc6acfa/etsy-3.jpg","https://media.gemworkers.com/items/d4d6e835-f47e-460f-9e00-95ee3bc6acfa/etsy-4.jpg","https://media.gemworkers.com/items/d4d6e835-f47e-460f-9e00-95ee3bc6acfa/etsy-5.jpg","https://media.gemworkers.com/items/d4d6e835-f47e-460f-9e00-95ee3bc6acfa/etsy-6.jpg","https://media.gemworkers.com/items/d4d6e835-f47e-460f-9e00-95ee3bc6acfa/etsy-7.jpg","https://media.gemworkers.com/items/d4d6e835-f47e-460f-9e00-95ee3bc6acfa/etsy-8.jpg","https://media.gemworkers.com/items/d4d6e835-f47e-460f-9e00-95ee3bc6acfa/etsy-9.jpg","https://media.gemworkers.com/items/d4d6e835-f47e-460f-9e00-95ee3bc6acfa/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Rings For Men,Rings For Women,Tourmaline Jewellery,Natural Stone,bicolour Tourmaline,Lagoon tourmaline,Bluegreen tourmaline,blue tourmaline,indigo tourmaline,Oceangemsminerals,rare tourmaline,ink blue tourmaline,Unique Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('15c7f758-284d-4d6a-9013-2f3fab66699c', '1.15 Cts Rubilite Tourmaline', 'Gorgeous Rubilite Tourmaline best for ring 💍 

1.15 Cts
8 x 5.8 x 4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 357, 1, 'loose_stone', 'Tourmaline', 'Rubellite', 1.15, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/15c7f758-284d-4d6a-9013-2f3fab66699c/etsy-1.jpg","https://media.gemworkers.com/items/15c7f758-284d-4d6a-9013-2f3fab66699c/etsy-2.jpg","https://media.gemworkers.com/items/15c7f758-284d-4d6a-9013-2f3fab66699c/etsy-3.jpg","https://media.gemworkers.com/items/15c7f758-284d-4d6a-9013-2f3fab66699c/etsy-4.jpg","https://media.gemworkers.com/items/15c7f758-284d-4d6a-9013-2f3fab66699c/etsy-5.jpg","https://media.gemworkers.com/items/15c7f758-284d-4d6a-9013-2f3fab66699c/etsy-6.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 400 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('2d9f1a38-cc69-45b5-8f7d-1acfdecc1c98', '13.65 Cts Bicolour Tourmaline lot', 'unique combinations tourmaline lot

Very Bright And Glowing Polish 

At very reasonable price 

Good size and lustre

13.65 Cts
7.1 to 5.1mm

Unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 13.65, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/2d9f1a38-cc69-45b5-8f7d-1acfdecc1c98/etsy-1.jpg","https://media.gemworkers.com/items/2d9f1a38-cc69-45b5-8f7d-1acfdecc1c98/etsy-2.jpg","https://media.gemworkers.com/items/2d9f1a38-cc69-45b5-8f7d-1acfdecc1c98/etsy-3.jpg","https://media.gemworkers.com/items/2d9f1a38-cc69-45b5-8f7d-1acfdecc1c98/etsy-4.jpg","https://media.gemworkers.com/items/2d9f1a38-cc69-45b5-8f7d-1acfdecc1c98/etsy-5.jpg","https://media.gemworkers.com/items/2d9f1a38-cc69-45b5-8f7d-1acfdecc1c98/etsy-6.jpg","https://media.gemworkers.com/items/2d9f1a38-cc69-45b5-8f7d-1acfdecc1c98/etsy-7.jpg","https://media.gemworkers.com/items/2d9f1a38-cc69-45b5-8f7d-1acfdecc1c98/etsy-8.jpg","https://media.gemworkers.com/items/2d9f1a38-cc69-45b5-8f7d-1acfdecc1c98/etsy-9.jpg","https://media.gemworkers.com/items/2d9f1a38-cc69-45b5-8f7d-1acfdecc1c98/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Tricolour Tourmaline,Tourmaline Pairs,Tricolour Pairs,Unique Tourmaline,Unique Pairs,Blue Tricolour Pairs,Blue tourmaline pair,Lagoon Tourmaline,Neon Tourmaline,Rare Tourmaline,Rare Tricolour Pairs,Oceangemsminerals,Ink blue Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('90a9dfff-fe61-430d-b225-48d71159806d', '1.60 Cts Rubilite Tourmaline', 'Gorgeous Rubilite Tourmaline best for ring 💍 

1.60 Cts
9.8 x 7.1 x 3.4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', 'Rubellite', 1.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/90a9dfff-fe61-430d-b225-48d71159806d/etsy-1.jpg","https://media.gemworkers.com/items/90a9dfff-fe61-430d-b225-48d71159806d/etsy-2.jpg","https://media.gemworkers.com/items/90a9dfff-fe61-430d-b225-48d71159806d/etsy-3.jpg","https://media.gemworkers.com/items/90a9dfff-fe61-430d-b225-48d71159806d/etsy-4.jpg","https://media.gemworkers.com/items/90a9dfff-fe61-430d-b225-48d71159806d/etsy-5.jpg","https://media.gemworkers.com/items/90a9dfff-fe61-430d-b225-48d71159806d/etsy-6.jpg","https://media.gemworkers.com/items/90a9dfff-fe61-430d-b225-48d71159806d/etsy-7.jpg","https://media.gemworkers.com/items/90a9dfff-fe61-430d-b225-48d71159806d/etsy-8.jpg","https://media.gemworkers.com/items/90a9dfff-fe61-430d-b225-48d71159806d/etsy-9.jpg","https://media.gemworkers.com/items/90a9dfff-fe61-430d-b225-48d71159806d/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('012ee6a0-340c-4270-b2ed-b6f58d69ae3b', '11.45 Cts Bicolour Tourmaline lot', 'unique combinations tourmaline lot

Very Bright And Glowing Polish 

At very reasonable price 

Good size and lustre

11.45 Cts
7.2 to 5.6mm

Unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 11.45, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/012ee6a0-340c-4270-b2ed-b6f58d69ae3b/etsy-1.jpg","https://media.gemworkers.com/items/012ee6a0-340c-4270-b2ed-b6f58d69ae3b/etsy-2.jpg","https://media.gemworkers.com/items/012ee6a0-340c-4270-b2ed-b6f58d69ae3b/etsy-3.jpg","https://media.gemworkers.com/items/012ee6a0-340c-4270-b2ed-b6f58d69ae3b/etsy-4.jpg","https://media.gemworkers.com/items/012ee6a0-340c-4270-b2ed-b6f58d69ae3b/etsy-5.jpg","https://media.gemworkers.com/items/012ee6a0-340c-4270-b2ed-b6f58d69ae3b/etsy-6.jpg","https://media.gemworkers.com/items/012ee6a0-340c-4270-b2ed-b6f58d69ae3b/etsy-7.jpg","https://media.gemworkers.com/items/012ee6a0-340c-4270-b2ed-b6f58d69ae3b/etsy-8.jpg","https://media.gemworkers.com/items/012ee6a0-340c-4270-b2ed-b6f58d69ae3b/etsy-9.jpg","https://media.gemworkers.com/items/012ee6a0-340c-4270-b2ed-b6f58d69ae3b/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Tricolour Tourmaline,Tourmaline Pairs,Tricolour Pairs,Unique Tourmaline,Unique Pairs,Blue Tricolour Pairs,Blue tourmaline pair,Lagoon Tourmaline,Neon Tourmaline,Rare Tourmaline,Rare Tricolour Pairs,Oceangemsminerals,Ink blue Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('ca5087c4-e4ab-4234-9651-46173b947039', '0.8 Cts Ink Blue Tourmaline', 'Top Ink Blue Colour Tourmaline Emerald Cut 

rare find

0.80 Cts
6.1 x 4.3 x 3.4mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 107, 1, 'loose_stone', 'Tourmaline', NULL, 0.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/ca5087c4-e4ab-4234-9651-46173b947039/etsy-1.jpg","https://media.gemworkers.com/items/ca5087c4-e4ab-4234-9651-46173b947039/etsy-2.jpg","https://media.gemworkers.com/items/ca5087c4-e4ab-4234-9651-46173b947039/etsy-3.jpg","https://media.gemworkers.com/items/ca5087c4-e4ab-4234-9651-46173b947039/etsy-4.jpg","https://media.gemworkers.com/items/ca5087c4-e4ab-4234-9651-46173b947039/etsy-5.jpg","https://media.gemworkers.com/items/ca5087c4-e4ab-4234-9651-46173b947039/etsy-6.jpg","https://media.gemworkers.com/items/ca5087c4-e4ab-4234-9651-46173b947039/etsy-7.jpg","https://media.gemworkers.com/items/ca5087c4-e4ab-4234-9651-46173b947039/etsy-8.jpg","https://media.gemworkers.com/items/ca5087c4-e4ab-4234-9651-46173b947039/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 120 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('83d6722e-e973-4842-9c25-9113aa9e33af', '25.30 Cts Rubelite Slices', 'Gorgeous Rubilite Slices Lot With Pairs

25.30 Cts
10 to 22.3mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 161, 1, 'loose_stone', 'Tourmaline', 'Rubellite', 25.3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/83d6722e-e973-4842-9c25-9113aa9e33af/etsy-1.jpg","https://media.gemworkers.com/items/83d6722e-e973-4842-9c25-9113aa9e33af/etsy-2.jpg","https://media.gemworkers.com/items/83d6722e-e973-4842-9c25-9113aa9e33af/etsy-3.jpg","https://media.gemworkers.com/items/83d6722e-e973-4842-9c25-9113aa9e33af/etsy-4.jpg","https://media.gemworkers.com/items/83d6722e-e973-4842-9c25-9113aa9e33af/etsy-5.jpg","https://media.gemworkers.com/items/83d6722e-e973-4842-9c25-9113aa9e33af/etsy-6.jpg","https://media.gemworkers.com/items/83d6722e-e973-4842-9c25-9113aa9e33af/etsy-7.jpg","https://media.gemworkers.com/items/83d6722e-e973-4842-9c25-9113aa9e33af/etsy-8.jpg","https://media.gemworkers.com/items/83d6722e-e973-4842-9c25-9113aa9e33af/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 180 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('632cbf30-cbe2-4f97-8138-2f664b933a70', '1.40 Cts Natural Bicolour Afghan Tourmaline', 'Gorgeous Mesmerising Natural Bicolour Afghan Tourmaline 

high lustre, Saturated Colour.

1.40 Cts
9.7 x 5.1 x 2.7mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 125, 1, 'loose_stone', 'Tourmaline', NULL, 1.4, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/632cbf30-cbe2-4f97-8138-2f664b933a70/etsy-1.jpg","https://media.gemworkers.com/items/632cbf30-cbe2-4f97-8138-2f664b933a70/etsy-2.jpg","https://media.gemworkers.com/items/632cbf30-cbe2-4f97-8138-2f664b933a70/etsy-3.jpg","https://media.gemworkers.com/items/632cbf30-cbe2-4f97-8138-2f664b933a70/etsy-4.jpg","https://media.gemworkers.com/items/632cbf30-cbe2-4f97-8138-2f664b933a70/etsy-5.jpg","https://media.gemworkers.com/items/632cbf30-cbe2-4f97-8138-2f664b933a70/etsy-6.jpg","https://media.gemworkers.com/items/632cbf30-cbe2-4f97-8138-2f664b933a70/etsy-7.jpg","https://media.gemworkers.com/items/632cbf30-cbe2-4f97-8138-2f664b933a70/etsy-8.jpg","https://media.gemworkers.com/items/632cbf30-cbe2-4f97-8138-2f664b933a70/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 140 USD, converted at ECB rate. Etsy tags: Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery findings,gift for her,natural stone,Oceangemsminerals,apple green colour,Bicolour Tourmaline,Natural Bicolour,Unheated Tourmaline,Lipstick Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('ec9d806d-4728-4436-b821-f4d21960f55d', '11.95 Cts Tourmaline Lot For Necklace', 'Gorgeous Tourmaline Lot For Necklace 

good lustre and nice polish

11.95 Cts
4.5 to 9mm

unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 134, 1, 'jewelry', 'Tourmaline', NULL, 11.95, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/ec9d806d-4728-4436-b821-f4d21960f55d/etsy-1.jpg","https://media.gemworkers.com/items/ec9d806d-4728-4436-b821-f4d21960f55d/etsy-2.jpg","https://media.gemworkers.com/items/ec9d806d-4728-4436-b821-f4d21960f55d/etsy-3.jpg","https://media.gemworkers.com/items/ec9d806d-4728-4436-b821-f4d21960f55d/etsy-4.jpg","https://media.gemworkers.com/items/ec9d806d-4728-4436-b821-f4d21960f55d/etsy-5.jpg","https://media.gemworkers.com/items/ec9d806d-4728-4436-b821-f4d21960f55d/etsy-6.jpg","https://media.gemworkers.com/items/ec9d806d-4728-4436-b821-f4d21960f55d/etsy-7.jpg","https://media.gemworkers.com/items/ec9d806d-4728-4436-b821-f4d21960f55d/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 150 USD, converted at ECB rate. Etsy tags: Bicolour Tourmaline,Pink Tourmaline,AppleGreenTourmaline,tourmaline rings,unique tourmaline,rare tourmaline,Handmadejewellery,jewellers,gift for her,natural stone,lagoon tourmaline,olive tourmaline,Green Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('27534af7-9b72-4d47-a20b-61bdbbada5ac', '7.4 Cts Mix Colour Tourmaline Lot', 'Mix Beautiful Colour Tourmaline Lot

More Beautiful In Real.

7.4 Cts
5.8 to 7.5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 7.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/27534af7-9b72-4d47-a20b-61bdbbada5ac/etsy-1.jpg","https://media.gemworkers.com/items/27534af7-9b72-4d47-a20b-61bdbbada5ac/etsy-2.jpg","https://media.gemworkers.com/items/27534af7-9b72-4d47-a20b-61bdbbada5ac/etsy-3.jpg","https://media.gemworkers.com/items/27534af7-9b72-4d47-a20b-61bdbbada5ac/etsy-4.jpg","https://media.gemworkers.com/items/27534af7-9b72-4d47-a20b-61bdbbada5ac/etsy-5.jpg","https://media.gemworkers.com/items/27534af7-9b72-4d47-a20b-61bdbbada5ac/etsy-6.jpg","https://media.gemworkers.com/items/27534af7-9b72-4d47-a20b-61bdbbada5ac/etsy-7.jpg","https://media.gemworkers.com/items/27534af7-9b72-4d47-a20b-61bdbbada5ac/etsy-8.jpg","https://media.gemworkers.com/items/27534af7-9b72-4d47-a20b-61bdbbada5ac/etsy-9.jpg","https://media.gemworkers.com/items/27534af7-9b72-4d47-a20b-61bdbbada5ac/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('e25bf1c3-4976-495b-85d5-a5224ea8c479', '1.40 Cts Yellow Tourmaline Pair', 'yellow tourmaline pair  

Ethically Sourced, Very Bright Colour

1.40 Cts
5.1 x 4.7 x 4.1mm

Unheated,Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 1.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/e25bf1c3-4976-495b-85d5-a5224ea8c479/etsy-1.jpg","https://media.gemworkers.com/items/e25bf1c3-4976-495b-85d5-a5224ea8c479/etsy-2.jpg","https://media.gemworkers.com/items/e25bf1c3-4976-495b-85d5-a5224ea8c479/etsy-3.jpg","https://media.gemworkers.com/items/e25bf1c3-4976-495b-85d5-a5224ea8c479/etsy-4.jpg","https://media.gemworkers.com/items/e25bf1c3-4976-495b-85d5-a5224ea8c479/etsy-5.jpg","https://media.gemworkers.com/items/e25bf1c3-4976-495b-85d5-a5224ea8c479/etsy-6.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: jewellery,tourmaline pair,earrings,tourmaline jewellery,bicolour tourmaline,y2k earrings stud,Jewellery Making,Jewellery Findings,Jewellery Supplies,Natural Stone,Tourmaline Earrings,Loose Gemstones,Yellow Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('7fddaed2-607a-4d37-a275-9500156ad942', '2 Cts Hot Pink Tourmaline', 'Gorgeous Hot Pink Tourmaline best for ring 💍 

Perfectly Cut

2.00 Cts 
7.4 x 6.7 x 5.4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 250, 1, 'loose_stone', 'Tourmaline', NULL, 2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/7fddaed2-607a-4d37-a275-9500156ad942/etsy-1.jpg","https://media.gemworkers.com/items/7fddaed2-607a-4d37-a275-9500156ad942/etsy-2.jpg","https://media.gemworkers.com/items/7fddaed2-607a-4d37-a275-9500156ad942/etsy-3.jpg","https://media.gemworkers.com/items/7fddaed2-607a-4d37-a275-9500156ad942/etsy-4.jpg","https://media.gemworkers.com/items/7fddaed2-607a-4d37-a275-9500156ad942/etsy-5.jpg","https://media.gemworkers.com/items/7fddaed2-607a-4d37-a275-9500156ad942/etsy-6.jpg","https://media.gemworkers.com/items/7fddaed2-607a-4d37-a275-9500156ad942/etsy-7.jpg","https://media.gemworkers.com/items/7fddaed2-607a-4d37-a275-9500156ad942/etsy-8.jpg","https://media.gemworkers.com/items/7fddaed2-607a-4d37-a275-9500156ad942/etsy-9.jpg","https://media.gemworkers.com/items/7fddaed2-607a-4d37-a275-9500156ad942/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 280 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('0651f65e-434d-4cac-b351-c54ac7c384d4', '0.9 Cts Hot Pink Tourmaline', 'Gorgeous Hot Pink Tourmaline best for ring 💍 

Perfectly Cut

0.90 Cts
5.9 x 5.1 x 3.9mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 250, 1, 'loose_stone', 'Tourmaline', NULL, 0.9, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/0651f65e-434d-4cac-b351-c54ac7c384d4/etsy-1.jpg","https://media.gemworkers.com/items/0651f65e-434d-4cac-b351-c54ac7c384d4/etsy-2.jpg","https://media.gemworkers.com/items/0651f65e-434d-4cac-b351-c54ac7c384d4/etsy-3.jpg","https://media.gemworkers.com/items/0651f65e-434d-4cac-b351-c54ac7c384d4/etsy-4.jpg","https://media.gemworkers.com/items/0651f65e-434d-4cac-b351-c54ac7c384d4/etsy-5.jpg","https://media.gemworkers.com/items/0651f65e-434d-4cac-b351-c54ac7c384d4/etsy-6.jpg","https://media.gemworkers.com/items/0651f65e-434d-4cac-b351-c54ac7c384d4/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 280 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('5dc28aab-3d4c-4061-ae9d-6049ebe4697f', '8.7 Cts Seafoam Tourmaline lot', 'Mesmerising Seafoam Blue colour afghan tourmaline 

Ethically sourced 

 lustre and brilliance 

8.70 Cts
10.4 to 5.6mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 8.7, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/5dc28aab-3d4c-4061-ae9d-6049ebe4697f/etsy-1.jpg","https://media.gemworkers.com/items/5dc28aab-3d4c-4061-ae9d-6049ebe4697f/etsy-2.jpg","https://media.gemworkers.com/items/5dc28aab-3d4c-4061-ae9d-6049ebe4697f/etsy-3.jpg","https://media.gemworkers.com/items/5dc28aab-3d4c-4061-ae9d-6049ebe4697f/etsy-4.jpg","https://media.gemworkers.com/items/5dc28aab-3d4c-4061-ae9d-6049ebe4697f/etsy-5.jpg","https://media.gemworkers.com/items/5dc28aab-3d4c-4061-ae9d-6049ebe4697f/etsy-6.jpg","https://media.gemworkers.com/items/5dc28aab-3d4c-4061-ae9d-6049ebe4697f/etsy-7.jpg","https://media.gemworkers.com/items/5dc28aab-3d4c-4061-ae9d-6049ebe4697f/etsy-8.jpg","https://media.gemworkers.com/items/5dc28aab-3d4c-4061-ae9d-6049ebe4697f/etsy-9.jpg","https://media.gemworkers.com/items/5dc28aab-3d4c-4061-ae9d-6049ebe4697f/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Jewellery Supplies,Jewellery Making,DIY Jewellery Making,Gift For Her,Rings For Men,Natural Stone,Silver Sterling,Gold Ring,Tourmaline Jewellery,Tourmaline Supplies,Afghan Tourmaline,y2k earrings stud,Seafoam Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('64a5a784-92c6-4bcd-9ee4-3b1878aa895c', '1.85 Cts Bluegreen Tourmaline', 'Unique Natural Afghan Tourmalines

Bright and lustre

1.85 Cts
5.6 x 5 x 3.9mm
5.6 x 4.5 x 3.5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 161, 1, 'loose_stone', 'Tourmaline', NULL, 1.85, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/64a5a784-92c6-4bcd-9ee4-3b1878aa895c/etsy-1.jpg","https://media.gemworkers.com/items/64a5a784-92c6-4bcd-9ee4-3b1878aa895c/etsy-2.jpg","https://media.gemworkers.com/items/64a5a784-92c6-4bcd-9ee4-3b1878aa895c/etsy-3.jpg","https://media.gemworkers.com/items/64a5a784-92c6-4bcd-9ee4-3b1878aa895c/etsy-4.jpg","https://media.gemworkers.com/items/64a5a784-92c6-4bcd-9ee4-3b1878aa895c/etsy-5.jpg","https://media.gemworkers.com/items/64a5a784-92c6-4bcd-9ee4-3b1878aa895c/etsy-6.jpg","https://media.gemworkers.com/items/64a5a784-92c6-4bcd-9ee4-3b1878aa895c/etsy-7.jpg","https://media.gemworkers.com/items/64a5a784-92c6-4bcd-9ee4-3b1878aa895c/etsy-8.jpg","https://media.gemworkers.com/items/64a5a784-92c6-4bcd-9ee4-3b1878aa895c/etsy-9.jpg","https://media.gemworkers.com/items/64a5a784-92c6-4bcd-9ee4-3b1878aa895c/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 180 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('d3a57ce1-9305-42bb-b0ed-b061c55ad9b4', '17.55 Cts Aquamarine', 'big size Aquamarine Emerald Cut

ethically sourced 

17.55 Cts
25.1 x 11 x 8.20 mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 357, 1, 'loose_stone', 'Aquamarine', NULL, 17.55, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/d3a57ce1-9305-42bb-b0ed-b061c55ad9b4/etsy-1.jpg","https://media.gemworkers.com/items/d3a57ce1-9305-42bb-b0ed-b061c55ad9b4/etsy-2.jpg","https://media.gemworkers.com/items/d3a57ce1-9305-42bb-b0ed-b061c55ad9b4/etsy-3.jpg","https://media.gemworkers.com/items/d3a57ce1-9305-42bb-b0ed-b061c55ad9b4/etsy-4.jpg","https://media.gemworkers.com/items/d3a57ce1-9305-42bb-b0ed-b061c55ad9b4/etsy-5.jpg","https://media.gemworkers.com/items/d3a57ce1-9305-42bb-b0ed-b061c55ad9b4/etsy-6.jpg","https://media.gemworkers.com/items/d3a57ce1-9305-42bb-b0ed-b061c55ad9b4/etsy-7.jpg","https://media.gemworkers.com/items/d3a57ce1-9305-42bb-b0ed-b061c55ad9b4/etsy-8.jpg","https://media.gemworkers.com/items/d3a57ce1-9305-42bb-b0ed-b061c55ad9b4/etsy-9.jpg","https://media.gemworkers.com/items/d3a57ce1-9305-42bb-b0ed-b061c55ad9b4/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 400 USD, converted at ECB rate. Etsy tags: Santa Maria Cabochon,Blue Aquamarine,Unique Aquamarine,Rare Aquamarine,Aquamarine Cabochons,Bicolour Aquamarine,Bicolour Cabochons,Blue Cabochons,Lagoon Cabochons,Natural Stone,jewels,Oceangemsminerals,Rare Cabochons.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('3e4457be-d568-49d9-93aa-db2552ac7937', '2 Cts Mint Green tourmalines', 'Mesmerising Mint Green Colour Tourmaline 

High Lustre And Brilliance , Top Colours

Perfectly Cut 

2.00 Cts
5.5 x 5.5 x 4mm
6 x 5.5 x 4.5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 134, 1, 'loose_stone', 'Tourmaline', NULL, 2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/3e4457be-d568-49d9-93aa-db2552ac7937/etsy-1.jpg","https://media.gemworkers.com/items/3e4457be-d568-49d9-93aa-db2552ac7937/etsy-2.jpg","https://media.gemworkers.com/items/3e4457be-d568-49d9-93aa-db2552ac7937/etsy-3.jpg","https://media.gemworkers.com/items/3e4457be-d568-49d9-93aa-db2552ac7937/etsy-4.jpg","https://media.gemworkers.com/items/3e4457be-d568-49d9-93aa-db2552ac7937/etsy-5.jpg","https://media.gemworkers.com/items/3e4457be-d568-49d9-93aa-db2552ac7937/etsy-6.jpg","https://media.gemworkers.com/items/3e4457be-d568-49d9-93aa-db2552ac7937/etsy-7.jpg","https://media.gemworkers.com/items/3e4457be-d568-49d9-93aa-db2552ac7937/etsy-8.jpg","https://media.gemworkers.com/items/3e4457be-d568-49d9-93aa-db2552ac7937/etsy-9.jpg","https://media.gemworkers.com/items/3e4457be-d568-49d9-93aa-db2552ac7937/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 150 USD, converted at ECB rate. Etsy tags: Gift For Her,Rings For Men,Rings For Women,Natural Stone,Silver Sterling,Gold Ring,Tourmaline Jewellery,Seafoam Tourmaline,Mint Tourmaline,Blue Tourmaline,Bluegreen tourmaline,lagoon tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('469ddc50-a9c4-4639-93a0-546a781f3964', '6.40 Cts Neon Lagoon Tourmaline', 'Gorgeous Mesmerising Rare  Neon Lagoon Blue Colour Afghan Tourmaline 

6.40 Cts
10.5 x 9.5 x 8.5mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 326, 1, 'loose_stone', 'Tourmaline', NULL, 6.4, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/469ddc50-a9c4-4639-93a0-546a781f3964/etsy-1.jpg","https://media.gemworkers.com/items/469ddc50-a9c4-4639-93a0-546a781f3964/etsy-2.jpg","https://media.gemworkers.com/items/469ddc50-a9c4-4639-93a0-546a781f3964/etsy-3.jpg","https://media.gemworkers.com/items/469ddc50-a9c4-4639-93a0-546a781f3964/etsy-4.jpg","https://media.gemworkers.com/items/469ddc50-a9c4-4639-93a0-546a781f3964/etsy-5.jpg","https://media.gemworkers.com/items/469ddc50-a9c4-4639-93a0-546a781f3964/etsy-6.jpg","https://media.gemworkers.com/items/469ddc50-a9c4-4639-93a0-546a781f3964/etsy-7.jpg","https://media.gemworkers.com/items/469ddc50-a9c4-4639-93a0-546a781f3964/etsy-8.jpg","https://media.gemworkers.com/items/469ddc50-a9c4-4639-93a0-546a781f3964/etsy-9.jpg","https://media.gemworkers.com/items/469ddc50-a9c4-4639-93a0-546a781f3964/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 365 USD, converted at ECB rate. Etsy tags: Gold Rings,Rings For Men,Rings For Women,Tourmaline Jewellery,Natural Stone,bicolour Tourmaline,Lagoon tourmaline,Bluegreen tourmaline,blue tourmaline,indigo tourmaline,Oceangemsminerals,rare tourmaline,ink blue tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('bcb19532-7bea-40a9-b0df-d4e974fe0fa5', '2.20 Cts teal blue and seafoam Tourmalines', 'Teal blue and seafoam colour tourmalines

mesmerising rare colour, cute looking tourmaline.

2.20 Cts
6 x 5 x 4.5mm
8 x 5 x 4mm

no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 161, 1, 'loose_stone', 'Tourmaline', NULL, 2.2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/bcb19532-7bea-40a9-b0df-d4e974fe0fa5/etsy-1.jpg","https://media.gemworkers.com/items/bcb19532-7bea-40a9-b0df-d4e974fe0fa5/etsy-2.jpg","https://media.gemworkers.com/items/bcb19532-7bea-40a9-b0df-d4e974fe0fa5/etsy-3.jpg","https://media.gemworkers.com/items/bcb19532-7bea-40a9-b0df-d4e974fe0fa5/etsy-4.jpg","https://media.gemworkers.com/items/bcb19532-7bea-40a9-b0df-d4e974fe0fa5/etsy-6.jpg","https://media.gemworkers.com/items/bcb19532-7bea-40a9-b0df-d4e974fe0fa5/etsy-7.jpg","https://media.gemworkers.com/items/bcb19532-7bea-40a9-b0df-d4e974fe0fa5/etsy-8.jpg","https://media.gemworkers.com/items/bcb19532-7bea-40a9-b0df-d4e974fe0fa5/etsy-9.jpg","https://media.gemworkers.com/items/bcb19532-7bea-40a9-b0df-d4e974fe0fa5/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 180 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Rings,Blue Tourmaline,Gift For Her,Rings For Women,Rings For Men,Gold Rings,Natural Stone,lagoon tourmaline,indigo tourmaline,indicolitetourmaline,Oceangemsminerals,ink blue tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('b4a66259-72dd-4d05-a94b-20955011fef5', '2.20 Cts Indigo blue Tourmaline', 'indigo blue colour tourmaline 

mesmerising rare colour, cute looking tourmaline.

2.20 Cts
7.8 x 7 x 5.5mm

no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 161, 1, 'loose_stone', 'Tourmaline', NULL, 2.2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/b4a66259-72dd-4d05-a94b-20955011fef5/etsy-1.jpg","https://media.gemworkers.com/items/b4a66259-72dd-4d05-a94b-20955011fef5/etsy-2.jpg","https://media.gemworkers.com/items/b4a66259-72dd-4d05-a94b-20955011fef5/etsy-3.jpg","https://media.gemworkers.com/items/b4a66259-72dd-4d05-a94b-20955011fef5/etsy-4.jpg","https://media.gemworkers.com/items/b4a66259-72dd-4d05-a94b-20955011fef5/etsy-5.jpg","https://media.gemworkers.com/items/b4a66259-72dd-4d05-a94b-20955011fef5/etsy-6.jpg","https://media.gemworkers.com/items/b4a66259-72dd-4d05-a94b-20955011fef5/etsy-7.jpg","https://media.gemworkers.com/items/b4a66259-72dd-4d05-a94b-20955011fef5/etsy-8.jpg","https://media.gemworkers.com/items/b4a66259-72dd-4d05-a94b-20955011fef5/etsy-9.jpg","https://media.gemworkers.com/items/b4a66259-72dd-4d05-a94b-20955011fef5/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 180 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Rings,Blue Tourmaline,Gift For Her,Rings For Women,Rings For Men,Gold Rings,Natural Stone,lagoon tourmaline,indigo tourmaline,indicolitetourmaline,Oceangemsminerals,ink blue tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('940e932c-86ab-4d3e-b92a-d56175518700', '1.40 Cts Mints Green tourmaline', 'Mesmerising Mint Green Colour Tourmaline 

Small And Cute Piece, Good Colour.

1.40 Cts 
8 x 6 x 4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 89, 1, 'loose_stone', 'Tourmaline', NULL, 1.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/940e932c-86ab-4d3e-b92a-d56175518700/etsy-1.jpg","https://media.gemworkers.com/items/940e932c-86ab-4d3e-b92a-d56175518700/etsy-2.jpg","https://media.gemworkers.com/items/940e932c-86ab-4d3e-b92a-d56175518700/etsy-3.jpg","https://media.gemworkers.com/items/940e932c-86ab-4d3e-b92a-d56175518700/etsy-4.jpg","https://media.gemworkers.com/items/940e932c-86ab-4d3e-b92a-d56175518700/etsy-5.jpg","https://media.gemworkers.com/items/940e932c-86ab-4d3e-b92a-d56175518700/etsy-6.jpg","https://media.gemworkers.com/items/940e932c-86ab-4d3e-b92a-d56175518700/etsy-7.jpg","https://media.gemworkers.com/items/940e932c-86ab-4d3e-b92a-d56175518700/etsy-8.jpg","https://media.gemworkers.com/items/940e932c-86ab-4d3e-b92a-d56175518700/etsy-9.jpg","https://media.gemworkers.com/items/940e932c-86ab-4d3e-b92a-d56175518700/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 100 USD, converted at ECB rate. Etsy tags: Gift For Her,Rings For Men,Rings For Women,Natural Stone,Silver Sterling,Gold Ring,Tourmaline Jewellery,Seafoam Tourmaline,Mint Tourmaline,Blue Tourmaline,Bluegreen tourmaline,lagoon tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('ea680bcb-0ffb-4d61-8905-167cba577cc5', '2.40 Cts Ink Blue Tourmaline', 'Gorgeous Mesmerising Rare Ink Blue Colour Afghan Tourmaline 

Open Colour, Exceptional piece

2.40 Cts
9.5 x 6 x 5mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 172, 1, 'loose_stone', 'Tourmaline', NULL, 2.4, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/ea680bcb-0ffb-4d61-8905-167cba577cc5/etsy-1.jpg","https://media.gemworkers.com/items/ea680bcb-0ffb-4d61-8905-167cba577cc5/etsy-2.jpg","https://media.gemworkers.com/items/ea680bcb-0ffb-4d61-8905-167cba577cc5/etsy-3.jpg","https://media.gemworkers.com/items/ea680bcb-0ffb-4d61-8905-167cba577cc5/etsy-4.jpg","https://media.gemworkers.com/items/ea680bcb-0ffb-4d61-8905-167cba577cc5/etsy-5.jpg","https://media.gemworkers.com/items/ea680bcb-0ffb-4d61-8905-167cba577cc5/etsy-6.jpg","https://media.gemworkers.com/items/ea680bcb-0ffb-4d61-8905-167cba577cc5/etsy-7.jpg","https://media.gemworkers.com/items/ea680bcb-0ffb-4d61-8905-167cba577cc5/etsy-8.jpg","https://media.gemworkers.com/items/ea680bcb-0ffb-4d61-8905-167cba577cc5/etsy-9.jpg","https://media.gemworkers.com/items/ea680bcb-0ffb-4d61-8905-167cba577cc5/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 192 USD, converted at ECB rate. Etsy tags: Gold Rings,Rings For Men,Rings For Women,Tourmaline Jewellery,Natural Stone,bicolour Tourmaline,Lagoon tourmaline,Bluegreen tourmaline,blue tourmaline,indigo tourmaline,Oceangemsminerals,rare tourmaline,ink blue tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('a34cf7ac-d3e3-4093-9815-9dc020d9d018', '2.5 Cts Bluegreen and seafoam tourmaline', 'Mesmerising Seafoam And Bluegreen Colour Tourmaline 

Small And Cute Pieces, Good Colours 

2.50 Cts
6 x 6 x 4mm
7 x 6 x 4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 165, 1, 'loose_stone', 'Tourmaline', NULL, 2.5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/a34cf7ac-d3e3-4093-9815-9dc020d9d018/etsy-1.jpg","https://media.gemworkers.com/items/a34cf7ac-d3e3-4093-9815-9dc020d9d018/etsy-2.jpg","https://media.gemworkers.com/items/a34cf7ac-d3e3-4093-9815-9dc020d9d018/etsy-3.jpg","https://media.gemworkers.com/items/a34cf7ac-d3e3-4093-9815-9dc020d9d018/etsy-4.jpg","https://media.gemworkers.com/items/a34cf7ac-d3e3-4093-9815-9dc020d9d018/etsy-5.jpg","https://media.gemworkers.com/items/a34cf7ac-d3e3-4093-9815-9dc020d9d018/etsy-6.jpg","https://media.gemworkers.com/items/a34cf7ac-d3e3-4093-9815-9dc020d9d018/etsy-7.jpg","https://media.gemworkers.com/items/a34cf7ac-d3e3-4093-9815-9dc020d9d018/etsy-8.jpg","https://media.gemworkers.com/items/a34cf7ac-d3e3-4093-9815-9dc020d9d018/etsy-9.jpg","https://media.gemworkers.com/items/a34cf7ac-d3e3-4093-9815-9dc020d9d018/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 185 USD, converted at ECB rate. Etsy tags: Gift For Her,Rings For Men,Rings For Women,Natural Stone,Silver Sterling,Gold Ring,Tourmaline Jewellery,Seafoam Tourmaline,Mint Tourmaline,Blue Tourmaline,Bluegreen tourmaline,lagoon tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('2e63a926-efc9-4dc1-922a-962d6241b312', '1.55 Cts Hot Pink Tourmaline', 'Gorgeous Pink Tourmaline best for ring 💍 

1.55 Cts
7.2 x 6 x 4.6mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 317, 1, 'loose_stone', 'Tourmaline', NULL, 1.55, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/2e63a926-efc9-4dc1-922a-962d6241b312/etsy-1.jpg","https://media.gemworkers.com/items/2e63a926-efc9-4dc1-922a-962d6241b312/etsy-2.jpg","https://media.gemworkers.com/items/2e63a926-efc9-4dc1-922a-962d6241b312/etsy-3.jpg","https://media.gemworkers.com/items/2e63a926-efc9-4dc1-922a-962d6241b312/etsy-4.jpg","https://media.gemworkers.com/items/2e63a926-efc9-4dc1-922a-962d6241b312/etsy-5.jpg","https://media.gemworkers.com/items/2e63a926-efc9-4dc1-922a-962d6241b312/etsy-6.jpg","https://media.gemworkers.com/items/2e63a926-efc9-4dc1-922a-962d6241b312/etsy-7.jpg","https://media.gemworkers.com/items/2e63a926-efc9-4dc1-922a-962d6241b312/etsy-8.jpg","https://media.gemworkers.com/items/2e63a926-efc9-4dc1-922a-962d6241b312/etsy-9.jpg","https://media.gemworkers.com/items/2e63a926-efc9-4dc1-922a-962d6241b312/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 355 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('2ba06647-e1d1-43bd-9a99-6f531659d552', '3.5 Cts Hot Pink Tourmaline Pair', 'Gorgeous Hot Pink Tourmaline Pair

eye clean

3.50 cts
7 x 6 x 5.2mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 357, 1, 'loose_stone', 'Tourmaline', NULL, 3.5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/2ba06647-e1d1-43bd-9a99-6f531659d552/etsy-1.jpg","https://media.gemworkers.com/items/2ba06647-e1d1-43bd-9a99-6f531659d552/etsy-2.jpg","https://media.gemworkers.com/items/2ba06647-e1d1-43bd-9a99-6f531659d552/etsy-3.jpg","https://media.gemworkers.com/items/2ba06647-e1d1-43bd-9a99-6f531659d552/etsy-4.jpg","https://media.gemworkers.com/items/2ba06647-e1d1-43bd-9a99-6f531659d552/etsy-5.jpg","https://media.gemworkers.com/items/2ba06647-e1d1-43bd-9a99-6f531659d552/etsy-6.jpg","https://media.gemworkers.com/items/2ba06647-e1d1-43bd-9a99-6f531659d552/etsy-7.jpg","https://media.gemworkers.com/items/2ba06647-e1d1-43bd-9a99-6f531659d552/etsy-8.jpg","https://media.gemworkers.com/items/2ba06647-e1d1-43bd-9a99-6f531659d552/etsy-9.jpg","https://media.gemworkers.com/items/2ba06647-e1d1-43bd-9a99-6f531659d552/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 400 USD, converted at ECB rate. Etsy tags: Rings For Men,Rings For Women,Jewellery Stud,Tourmaline Rings,Gift For Her,Gold rings,Natural Stone,Handmade,Oceangemsminerals,Unique Tourmaline,Rare Tourmaline,Pink Tourmaline Lot,Tourmaline Pair.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('5e2a5b77-235c-4492-93c2-d2cb7d907a00', '49.70 Cts: Big Bicolour Tourmaline', 'To All The Bicolour Lovers Here Is An Incredible Opportunity Buy A Truly Exceptional And One Of A Kind Bicolour Tourmaline / Collectors Dream.

Lustre And Brilliance , “One Time Stone”

49.70 Cts
28.3 x 14.2 x 11.4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 2680, 1, 'loose_stone', 'Tourmaline', NULL, 49.7, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/5e2a5b77-235c-4492-93c2-d2cb7d907a00/etsy-1.jpg","https://media.gemworkers.com/items/5e2a5b77-235c-4492-93c2-d2cb7d907a00/etsy-2.jpg","https://media.gemworkers.com/items/5e2a5b77-235c-4492-93c2-d2cb7d907a00/etsy-3.jpg","https://media.gemworkers.com/items/5e2a5b77-235c-4492-93c2-d2cb7d907a00/etsy-4.jpg","https://media.gemworkers.com/items/5e2a5b77-235c-4492-93c2-d2cb7d907a00/etsy-5.jpg","https://media.gemworkers.com/items/5e2a5b77-235c-4492-93c2-d2cb7d907a00/etsy-6.jpg","https://media.gemworkers.com/items/5e2a5b77-235c-4492-93c2-d2cb7d907a00/etsy-7.jpg","https://media.gemworkers.com/items/5e2a5b77-235c-4492-93c2-d2cb7d907a00/etsy-8.jpg","https://media.gemworkers.com/items/5e2a5b77-235c-4492-93c2-d2cb7d907a00/etsy-9.jpg","https://media.gemworkers.com/items/5e2a5b77-235c-4492-93c2-d2cb7d907a00/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 3000 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,jewels,Handmadejewellery,gift for her,Topqualitytourmaline,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Collection Piece,Tricolour Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('38fb390b-2e4a-4872-badb-9a83a878ec38', '5.95 Cts Apple Green Peridot', 'bright Colour Peridot 

origin- pakistan 

pakistan peridot is one of the finest and top quality 

Loupe Clean

Excellent Cut

5.95 Cts
10.6 x 10.4 x 7.6mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 447, 1, 'loose_stone', 'Peridot', NULL, 5.95, 'ct', 'Pakistan', NULL, NULL, '["https://media.gemworkers.com/items/38fb390b-2e4a-4872-badb-9a83a878ec38/etsy-1.jpg","https://media.gemworkers.com/items/38fb390b-2e4a-4872-badb-9a83a878ec38/etsy-2.jpg","https://media.gemworkers.com/items/38fb390b-2e4a-4872-badb-9a83a878ec38/etsy-3.jpg","https://media.gemworkers.com/items/38fb390b-2e4a-4872-badb-9a83a878ec38/etsy-4.jpg","https://media.gemworkers.com/items/38fb390b-2e4a-4872-badb-9a83a878ec38/etsy-5.jpg","https://media.gemworkers.com/items/38fb390b-2e4a-4872-badb-9a83a878ec38/etsy-6.jpg","https://media.gemworkers.com/items/38fb390b-2e4a-4872-badb-9a83a878ec38/etsy-7.jpg","https://media.gemworkers.com/items/38fb390b-2e4a-4872-badb-9a83a878ec38/etsy-8.jpg","https://media.gemworkers.com/items/38fb390b-2e4a-4872-badb-9a83a878ec38/etsy-9.jpg","https://media.gemworkers.com/items/38fb390b-2e4a-4872-badb-9a83a878ec38/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 500 USD, converted at ECB rate. Etsy tags: jewellery supplies,jewellery findings,loose gemstones,gift for her,peridot pairs,peridot jewellery,pakistan peridot,green peridot,trillion peridot,y2k earrings stud,necklace findings,gold rings,Apple Green Peridot.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('44119846-3ba2-4758-af16-2d1d956a9edf', '1.80 Cts Seafoam Tourmaline', 'Gorgeous Seafoam Tourmaline 

Best For Ring 

1.80 carats 
Size:9.3x5x4.2mm

100% natural no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 1.8, 'ct', NULL, NULL, '9.3x5x4.2', '["https://media.gemworkers.com/items/44119846-3ba2-4758-af16-2d1d956a9edf/etsy-1.jpg","https://media.gemworkers.com/items/44119846-3ba2-4758-af16-2d1d956a9edf/etsy-2.jpg","https://media.gemworkers.com/items/44119846-3ba2-4758-af16-2d1d956a9edf/etsy-3.jpg","https://media.gemworkers.com/items/44119846-3ba2-4758-af16-2d1d956a9edf/etsy-4.jpg","https://media.gemworkers.com/items/44119846-3ba2-4758-af16-2d1d956a9edf/etsy-5.jpg","https://media.gemworkers.com/items/44119846-3ba2-4758-af16-2d1d956a9edf/etsy-6.jpg","https://media.gemworkers.com/items/44119846-3ba2-4758-af16-2d1d956a9edf/etsy-7.jpg","https://media.gemworkers.com/items/44119846-3ba2-4758-af16-2d1d956a9edf/etsy-8.jpg","https://media.gemworkers.com/items/44119846-3ba2-4758-af16-2d1d956a9edf/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Rings for women,rings for men,Lagoon Tourmaline,Blue Tourmaline,Tiffany Colour,Tiffany Tourmaline,Loose gemstones,natural stone,Jewels,jewellery making,jewellery supplies,jewellery findings,Handmadejewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('7a1e3d65-614f-4ed6-819a-3eb7ed8f0b3d', '1.40 Cts Ice Blue Colour Tourmaline', 'Top Quality Ice 🧊 Colour Tourmaline

rare find

1.40 Cts
6.1 x 5.6 x 5.3mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 134, 1, 'loose_stone', 'Tourmaline', NULL, 1.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/7a1e3d65-614f-4ed6-819a-3eb7ed8f0b3d/etsy-1.jpg","https://media.gemworkers.com/items/7a1e3d65-614f-4ed6-819a-3eb7ed8f0b3d/etsy-2.jpg","https://media.gemworkers.com/items/7a1e3d65-614f-4ed6-819a-3eb7ed8f0b3d/etsy-3.jpg","https://media.gemworkers.com/items/7a1e3d65-614f-4ed6-819a-3eb7ed8f0b3d/etsy-4.jpg","https://media.gemworkers.com/items/7a1e3d65-614f-4ed6-819a-3eb7ed8f0b3d/etsy-5.jpg","https://media.gemworkers.com/items/7a1e3d65-614f-4ed6-819a-3eb7ed8f0b3d/etsy-6.jpg","https://media.gemworkers.com/items/7a1e3d65-614f-4ed6-819a-3eb7ed8f0b3d/etsy-7.jpg","https://media.gemworkers.com/items/7a1e3d65-614f-4ed6-819a-3eb7ed8f0b3d/etsy-8.jpg","https://media.gemworkers.com/items/7a1e3d65-614f-4ed6-819a-3eb7ed8f0b3d/etsy-9.jpg","https://media.gemworkers.com/items/7a1e3d65-614f-4ed6-819a-3eb7ed8f0b3d/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 150 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('478ce5a2-a45a-41ae-b1db-b4a85cee5904', '14.90 Cts Mix Bicolour Tourmaline Lot', 'To All The Bicolour Lovers Here Is An Incredible Opportunity Buy A Truly Exceptional And One Of A Kind Bicolour Tourmaline Lot

Mix Bicolours

14.90 Cts
11.2 to 4.2mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 389, 1, 'loose_stone', 'Tourmaline', NULL, 14.9, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/478ce5a2-a45a-41ae-b1db-b4a85cee5904/etsy-1.jpg","https://media.gemworkers.com/items/478ce5a2-a45a-41ae-b1db-b4a85cee5904/etsy-2.jpg","https://media.gemworkers.com/items/478ce5a2-a45a-41ae-b1db-b4a85cee5904/etsy-3.jpg","https://media.gemworkers.com/items/478ce5a2-a45a-41ae-b1db-b4a85cee5904/etsy-4.jpg","https://media.gemworkers.com/items/478ce5a2-a45a-41ae-b1db-b4a85cee5904/etsy-5.jpg","https://media.gemworkers.com/items/478ce5a2-a45a-41ae-b1db-b4a85cee5904/etsy-6.jpg","https://media.gemworkers.com/items/478ce5a2-a45a-41ae-b1db-b4a85cee5904/etsy-7.jpg","https://media.gemworkers.com/items/478ce5a2-a45a-41ae-b1db-b4a85cee5904/etsy-8.jpg","https://media.gemworkers.com/items/478ce5a2-a45a-41ae-b1db-b4a85cee5904/etsy-9.jpg","https://media.gemworkers.com/items/478ce5a2-a45a-41ae-b1db-b4a85cee5904/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 435 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,jewels,Handmadejewellery,gift for her,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs,Canary Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('2aeb291d-59c0-478b-95d8-fe7f28930f8c', '2.15 Cts Hot Pink Tourmalines', 'Gorgeous Hot Pink Tourmalines 

Perfectly Cut

2.15 Cts
6 x 5.2 x 3.9mm
5.3 x 4.4 x 3.7mm
5.3 x 4.1 x 2.7mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 353, 1, 'loose_stone', 'Tourmaline', NULL, 2.15, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/2aeb291d-59c0-478b-95d8-fe7f28930f8c/etsy-1.jpg","https://media.gemworkers.com/items/2aeb291d-59c0-478b-95d8-fe7f28930f8c/etsy-2.jpg","https://media.gemworkers.com/items/2aeb291d-59c0-478b-95d8-fe7f28930f8c/etsy-3.jpg","https://media.gemworkers.com/items/2aeb291d-59c0-478b-95d8-fe7f28930f8c/etsy-4.jpg","https://media.gemworkers.com/items/2aeb291d-59c0-478b-95d8-fe7f28930f8c/etsy-5.jpg","https://media.gemworkers.com/items/2aeb291d-59c0-478b-95d8-fe7f28930f8c/etsy-6.jpg","https://media.gemworkers.com/items/2aeb291d-59c0-478b-95d8-fe7f28930f8c/etsy-7.jpg","https://media.gemworkers.com/items/2aeb291d-59c0-478b-95d8-fe7f28930f8c/etsy-8.jpg","https://media.gemworkers.com/items/2aeb291d-59c0-478b-95d8-fe7f28930f8c/etsy-9.jpg","https://media.gemworkers.com/items/2aeb291d-59c0-478b-95d8-fe7f28930f8c/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 395 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('de7ae139-3947-4f49-b09c-a21fd6e891e2', '7.10 Cts Mix Bicolour Tourmaline Lot', 'To All The Bicolour Lovers Here Is An Incredible Opportunity Buy A Truly Exceptional And One Of A Kind Bicolour Tourmaline Lot

Mix Bicolours

7.10 Cts
6.8 to 4.3mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 178, 1, 'loose_stone', 'Tourmaline', NULL, 7.1, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/de7ae139-3947-4f49-b09c-a21fd6e891e2/etsy-1.jpg","https://media.gemworkers.com/items/de7ae139-3947-4f49-b09c-a21fd6e891e2/etsy-2.jpg","https://media.gemworkers.com/items/de7ae139-3947-4f49-b09c-a21fd6e891e2/etsy-3.jpg","https://media.gemworkers.com/items/de7ae139-3947-4f49-b09c-a21fd6e891e2/etsy-4.jpg","https://media.gemworkers.com/items/de7ae139-3947-4f49-b09c-a21fd6e891e2/etsy-5.jpg","https://media.gemworkers.com/items/de7ae139-3947-4f49-b09c-a21fd6e891e2/etsy-6.jpg","https://media.gemworkers.com/items/de7ae139-3947-4f49-b09c-a21fd6e891e2/etsy-7.jpg","https://media.gemworkers.com/items/de7ae139-3947-4f49-b09c-a21fd6e891e2/etsy-8.jpg","https://media.gemworkers.com/items/de7ae139-3947-4f49-b09c-a21fd6e891e2/etsy-9.jpg","https://media.gemworkers.com/items/de7ae139-3947-4f49-b09c-a21fd6e891e2/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 199 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,jewels,Handmadejewellery,gift for her,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs,Canary Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('0863788f-e1af-4c19-b934-ea03b4a890f8', '8.8 Cts Hot Pink Tourmaline Lot', 'Gorgeous Hot Pink Tourmaline 

very rare colour, just like spinel

8.80 Cts 
7.8 to 7mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 536, 1, 'loose_stone', 'Tourmaline', NULL, 8.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/0863788f-e1af-4c19-b934-ea03b4a890f8/etsy-1.jpg","https://media.gemworkers.com/items/0863788f-e1af-4c19-b934-ea03b4a890f8/etsy-2.jpg","https://media.gemworkers.com/items/0863788f-e1af-4c19-b934-ea03b4a890f8/etsy-3.jpg","https://media.gemworkers.com/items/0863788f-e1af-4c19-b934-ea03b4a890f8/etsy-4.jpg","https://media.gemworkers.com/items/0863788f-e1af-4c19-b934-ea03b4a890f8/etsy-5.jpg","https://media.gemworkers.com/items/0863788f-e1af-4c19-b934-ea03b4a890f8/etsy-6.jpg","https://media.gemworkers.com/items/0863788f-e1af-4c19-b934-ea03b4a890f8/etsy-7.jpg","https://media.gemworkers.com/items/0863788f-e1af-4c19-b934-ea03b4a890f8/etsy-8.jpg","https://media.gemworkers.com/items/0863788f-e1af-4c19-b934-ea03b4a890f8/etsy-9.jpg","https://media.gemworkers.com/items/0863788f-e1af-4c19-b934-ea03b4a890f8/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 600 USD, converted at ECB rate. Etsy tags: Red Tourmaline,Hot Pink Tourmaline,Pink Tourmaline,Orange Tourmaline,Unique Tourmaline,Tourmaline Jewellery,Faceted Tourmaline,Step Cushion Cut,Feceted Tourmaline,Afghan Tourmaline,Oceangemsminerals,Purple Tourmaline,Lavender Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('2efd4e7f-fcf0-486f-bde3-205287c0dd4b', '6.6 Cts Hot Pink Tourmaline Lot', 'Gorgeous Hot Pink Tourmaline 

very rare colour, just like spinel

6.60 Cts
8.5 to 5.8mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 250, 1, 'loose_stone', 'Tourmaline', NULL, 6.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/2efd4e7f-fcf0-486f-bde3-205287c0dd4b/etsy-1.jpg","https://media.gemworkers.com/items/2efd4e7f-fcf0-486f-bde3-205287c0dd4b/etsy-2.jpg","https://media.gemworkers.com/items/2efd4e7f-fcf0-486f-bde3-205287c0dd4b/etsy-3.jpg","https://media.gemworkers.com/items/2efd4e7f-fcf0-486f-bde3-205287c0dd4b/etsy-4.jpg","https://media.gemworkers.com/items/2efd4e7f-fcf0-486f-bde3-205287c0dd4b/etsy-5.jpg","https://media.gemworkers.com/items/2efd4e7f-fcf0-486f-bde3-205287c0dd4b/etsy-6.jpg","https://media.gemworkers.com/items/2efd4e7f-fcf0-486f-bde3-205287c0dd4b/etsy-7.jpg","https://media.gemworkers.com/items/2efd4e7f-fcf0-486f-bde3-205287c0dd4b/etsy-8.jpg","https://media.gemworkers.com/items/2efd4e7f-fcf0-486f-bde3-205287c0dd4b/etsy-9.jpg","https://media.gemworkers.com/items/2efd4e7f-fcf0-486f-bde3-205287c0dd4b/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 280 USD, converted at ECB rate. Etsy tags: Red Tourmaline,Hot Pink Tourmaline,Pink Tourmaline,Orange Tourmaline,Unique Tourmaline,Tourmaline Jewellery,Faceted Tourmaline,Step Cushion Cut,Feceted Tourmaline,Afghan Tourmaline,Oceangemsminerals,Purple Tourmaline,Lavender Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('6c6b3d94-980a-4a96-808d-c2261cc020a0', '13.50 Cts Lagoon Bicolour Tourmaline.', 'Gorgeous Mesmerising Rare Lagoon Bicolour Natural Afghanistan Tourmaline 

More beautiful In real, One of a kind

13.50 Cts
13.5 x 13 x 10.5mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 603, 1, 'loose_stone', 'Tourmaline', NULL, 13.5, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/6c6b3d94-980a-4a96-808d-c2261cc020a0/etsy-1.jpg","https://media.gemworkers.com/items/6c6b3d94-980a-4a96-808d-c2261cc020a0/etsy-2.jpg","https://media.gemworkers.com/items/6c6b3d94-980a-4a96-808d-c2261cc020a0/etsy-3.jpg","https://media.gemworkers.com/items/6c6b3d94-980a-4a96-808d-c2261cc020a0/etsy-4.jpg","https://media.gemworkers.com/items/6c6b3d94-980a-4a96-808d-c2261cc020a0/etsy-5.jpg","https://media.gemworkers.com/items/6c6b3d94-980a-4a96-808d-c2261cc020a0/etsy-6.jpg","https://media.gemworkers.com/items/6c6b3d94-980a-4a96-808d-c2261cc020a0/etsy-7.jpg","https://media.gemworkers.com/items/6c6b3d94-980a-4a96-808d-c2261cc020a0/etsy-8.jpg","https://media.gemworkers.com/items/6c6b3d94-980a-4a96-808d-c2261cc020a0/etsy-9.jpg","https://media.gemworkers.com/items/6c6b3d94-980a-4a96-808d-c2261cc020a0/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 675 USD, converted at ECB rate. Etsy tags: Gold Rings,Rings For Men,Rings For Women,Gift For Her,Tourmaline Jewellery,Natural Stone,bicolour Tourmaline,Lagoon tourmaline,Bluegreen tourmaline,blue tourmaline,indigo tourmaline,Oceangemsminerals,rare tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('84885236-26ed-4e4c-b146-e75b12336e9c', '4.70 Cts Unique Blue Bicolour Tourmaline', 'Gorgeous Mesmerising Rare Bicolour Natural Afghanistan Tourmaline 

More beautiful In real, One of a kind

4.70 Cts
12 x 8 x 5.5mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 304, 1, 'loose_stone', 'Tourmaline', NULL, 4.7, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/84885236-26ed-4e4c-b146-e75b12336e9c/etsy-1.jpg","https://media.gemworkers.com/items/84885236-26ed-4e4c-b146-e75b12336e9c/etsy-2.jpg","https://media.gemworkers.com/items/84885236-26ed-4e4c-b146-e75b12336e9c/etsy-3.jpg","https://media.gemworkers.com/items/84885236-26ed-4e4c-b146-e75b12336e9c/etsy-4.jpg","https://media.gemworkers.com/items/84885236-26ed-4e4c-b146-e75b12336e9c/etsy-5.jpg","https://media.gemworkers.com/items/84885236-26ed-4e4c-b146-e75b12336e9c/etsy-6.jpg","https://media.gemworkers.com/items/84885236-26ed-4e4c-b146-e75b12336e9c/etsy-7.jpg","https://media.gemworkers.com/items/84885236-26ed-4e4c-b146-e75b12336e9c/etsy-8.jpg","https://media.gemworkers.com/items/84885236-26ed-4e4c-b146-e75b12336e9c/etsy-9.jpg","https://media.gemworkers.com/items/84885236-26ed-4e4c-b146-e75b12336e9c/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 340 USD, converted at ECB rate. Etsy tags: Gold Rings,Rings For Men,Rings For Women,Gift For Her,Tourmaline Jewellery,Natural Stone,bicolour Tourmaline,Lagoon tourmaline,Bluegreen tourmaline,blue tourmaline,indigo tourmaline,Oceangemsminerals,rare tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('4da1f99d-95e9-46b2-9cb4-7e5dd93cef1e', '9.10 Cts Neon Lagoon Tourmaline', 'Gorgeous Mesmerising Rare  Neon Lagoon Blue Colour Afghan Tourmaline 

9.10 Cts
12 x 11 x 8.5mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 326, 1, 'loose_stone', 'Tourmaline', NULL, 9.1, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/4da1f99d-95e9-46b2-9cb4-7e5dd93cef1e/etsy-1.jpg","https://media.gemworkers.com/items/4da1f99d-95e9-46b2-9cb4-7e5dd93cef1e/etsy-2.jpg","https://media.gemworkers.com/items/4da1f99d-95e9-46b2-9cb4-7e5dd93cef1e/etsy-3.jpg","https://media.gemworkers.com/items/4da1f99d-95e9-46b2-9cb4-7e5dd93cef1e/etsy-4.jpg","https://media.gemworkers.com/items/4da1f99d-95e9-46b2-9cb4-7e5dd93cef1e/etsy-5.jpg","https://media.gemworkers.com/items/4da1f99d-95e9-46b2-9cb4-7e5dd93cef1e/etsy-6.jpg","https://media.gemworkers.com/items/4da1f99d-95e9-46b2-9cb4-7e5dd93cef1e/etsy-7.jpg","https://media.gemworkers.com/items/4da1f99d-95e9-46b2-9cb4-7e5dd93cef1e/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 365 USD, converted at ECB rate. Etsy tags: Gold Rings,Rings For Men,Rings For Women,Tourmaline Jewellery,Natural Stone,bicolour Tourmaline,Lagoon tourmaline,Bluegreen tourmaline,blue tourmaline,indigo tourmaline,Oceangemsminerals,rare tourmaline,ink blue tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('5bd88998-02ab-4b86-837e-da27db1f93ca', '10.60 Cts Lagoon Bicolour Tourmaline.', 'Gorgeous Mesmerising Rare Lagoon Bicolour Natural Afghanistan Tourmaline 

More beautiful In real, One of a kind

10.60 Cts
13 x 13 x 9mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 304, 1, 'loose_stone', 'Tourmaline', NULL, 10.6, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/5bd88998-02ab-4b86-837e-da27db1f93ca/etsy-1.jpg","https://media.gemworkers.com/items/5bd88998-02ab-4b86-837e-da27db1f93ca/etsy-2.jpg","https://media.gemworkers.com/items/5bd88998-02ab-4b86-837e-da27db1f93ca/etsy-3.jpg","https://media.gemworkers.com/items/5bd88998-02ab-4b86-837e-da27db1f93ca/etsy-4.jpg","https://media.gemworkers.com/items/5bd88998-02ab-4b86-837e-da27db1f93ca/etsy-5.jpg","https://media.gemworkers.com/items/5bd88998-02ab-4b86-837e-da27db1f93ca/etsy-6.jpg","https://media.gemworkers.com/items/5bd88998-02ab-4b86-837e-da27db1f93ca/etsy-7.jpg","https://media.gemworkers.com/items/5bd88998-02ab-4b86-837e-da27db1f93ca/etsy-8.jpg","https://media.gemworkers.com/items/5bd88998-02ab-4b86-837e-da27db1f93ca/etsy-9.jpg","https://media.gemworkers.com/items/5bd88998-02ab-4b86-837e-da27db1f93ca/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 340 USD, converted at ECB rate. Etsy tags: Gold Rings,Rings For Men,Rings For Women,Gift For Her,Tourmaline Jewellery,Natural Stone,bicolour Tourmaline,Lagoon tourmaline,Bluegreen tourmaline,blue tourmaline,indigo tourmaline,Oceangemsminerals,rare tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('585bade8-925f-4d31-8598-1b99ff18d7b9', '93.80 Cts: Collectors Dream / Tricolour Tourmaline', 'To All The Bicolour Lovers Here Is An Incredible Opportunity Buy A Truly Exceptional And One Of A Kind Tricolour Tourmaline / Collectors Dream.

Lustre And Brilliance , “One Time Stone”

93.80 Cts
32.4 x 22.8 x 15.2mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 6701, 1, 'loose_stone', 'Tourmaline', NULL, 93.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/585bade8-925f-4d31-8598-1b99ff18d7b9/etsy-1.jpg","https://media.gemworkers.com/items/585bade8-925f-4d31-8598-1b99ff18d7b9/etsy-2.jpg","https://media.gemworkers.com/items/585bade8-925f-4d31-8598-1b99ff18d7b9/etsy-3.jpg","https://media.gemworkers.com/items/585bade8-925f-4d31-8598-1b99ff18d7b9/etsy-4.jpg","https://media.gemworkers.com/items/585bade8-925f-4d31-8598-1b99ff18d7b9/etsy-5.jpg","https://media.gemworkers.com/items/585bade8-925f-4d31-8598-1b99ff18d7b9/etsy-6.jpg","https://media.gemworkers.com/items/585bade8-925f-4d31-8598-1b99ff18d7b9/etsy-7.jpg","https://media.gemworkers.com/items/585bade8-925f-4d31-8598-1b99ff18d7b9/etsy-8.jpg","https://media.gemworkers.com/items/585bade8-925f-4d31-8598-1b99ff18d7b9/etsy-9.jpg","https://media.gemworkers.com/items/585bade8-925f-4d31-8598-1b99ff18d7b9/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 7500 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,jewels,Handmadejewellery,gift for her,Topqualitytourmaline,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Collection Piece,Tricolour Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('f158a277-5c9c-498d-a1ee-d39c47a6bbf9', '9.9 Cts Tricolour Tourmaline Pairs', 'To All The Bicolour Lovers Here Is An Incredible Opportunity Buy A Truly Exceptional And One Of A Kind Tricolour Tourmaline Pairs 

Purple, Pink, And Apple Green Combination 

9.9 Cts
9.1 x 5.9 x 3.6mm
8.4 x 5.5 x 3.8mm
8.4 x 4 x 3.2mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 536, 1, 'loose_stone', 'Tourmaline', NULL, 9.9, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/f158a277-5c9c-498d-a1ee-d39c47a6bbf9/etsy-1.jpg","https://media.gemworkers.com/items/f158a277-5c9c-498d-a1ee-d39c47a6bbf9/etsy-2.jpg","https://media.gemworkers.com/items/f158a277-5c9c-498d-a1ee-d39c47a6bbf9/etsy-3.jpg","https://media.gemworkers.com/items/f158a277-5c9c-498d-a1ee-d39c47a6bbf9/etsy-4.jpg","https://media.gemworkers.com/items/f158a277-5c9c-498d-a1ee-d39c47a6bbf9/etsy-5.jpg","https://media.gemworkers.com/items/f158a277-5c9c-498d-a1ee-d39c47a6bbf9/etsy-6.jpg","https://media.gemworkers.com/items/f158a277-5c9c-498d-a1ee-d39c47a6bbf9/etsy-7.jpg","https://media.gemworkers.com/items/f158a277-5c9c-498d-a1ee-d39c47a6bbf9/etsy-8.jpg","https://media.gemworkers.com/items/f158a277-5c9c-498d-a1ee-d39c47a6bbf9/etsy-9.jpg","https://media.gemworkers.com/items/f158a277-5c9c-498d-a1ee-d39c47a6bbf9/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 600 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,jewels,Handmadejewellery,gift for her,Topqualitytourmaline,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('ddc98420-bf46-4ad2-8919-243a2501a9b2', '7.60 Cts Mix Colour Tourmaline Lot', 'Mix Beautiful Colour Tourmaline Lot

More Beautiful In Real.

7.60 Cts
7.1 to 4.1mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 197, 1, 'loose_stone', 'Tourmaline', NULL, 7.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/ddc98420-bf46-4ad2-8919-243a2501a9b2/etsy-1.jpg","https://media.gemworkers.com/items/ddc98420-bf46-4ad2-8919-243a2501a9b2/etsy-2.jpg","https://media.gemworkers.com/items/ddc98420-bf46-4ad2-8919-243a2501a9b2/etsy-3.jpg","https://media.gemworkers.com/items/ddc98420-bf46-4ad2-8919-243a2501a9b2/etsy-4.jpg","https://media.gemworkers.com/items/ddc98420-bf46-4ad2-8919-243a2501a9b2/etsy-5.jpg","https://media.gemworkers.com/items/ddc98420-bf46-4ad2-8919-243a2501a9b2/etsy-6.jpg","https://media.gemworkers.com/items/ddc98420-bf46-4ad2-8919-243a2501a9b2/etsy-7.jpg","https://media.gemworkers.com/items/ddc98420-bf46-4ad2-8919-243a2501a9b2/etsy-8.jpg","https://media.gemworkers.com/items/ddc98420-bf46-4ad2-8919-243a2501a9b2/etsy-9.jpg","https://media.gemworkers.com/items/ddc98420-bf46-4ad2-8919-243a2501a9b2/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 220 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('5a59f339-0922-4d1f-a76b-6208bedc8fe0', '1.70 Cts Blue Green Tourmaline', 'Mesmerising Blue Green Colour Afghan Tourmaline 

Ethically Sourced, Eye Clean

Cut To Perfection 

high lustre and brilliance 

1.35 carats 

Size:8.8x4.6x3.8mm

Unheated, No treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 161, 1, 'loose_stone', 'Tourmaline', NULL, 1.7, 'ct', 'Afghanistan', NULL, '8.8x4.6x3.8', '["https://media.gemworkers.com/items/5a59f339-0922-4d1f-a76b-6208bedc8fe0/etsy-1.jpg","https://media.gemworkers.com/items/5a59f339-0922-4d1f-a76b-6208bedc8fe0/etsy-2.jpg","https://media.gemworkers.com/items/5a59f339-0922-4d1f-a76b-6208bedc8fe0/etsy-3.jpg","https://media.gemworkers.com/items/5a59f339-0922-4d1f-a76b-6208bedc8fe0/etsy-4.jpg","https://media.gemworkers.com/items/5a59f339-0922-4d1f-a76b-6208bedc8fe0/etsy-5.jpg","https://media.gemworkers.com/items/5a59f339-0922-4d1f-a76b-6208bedc8fe0/etsy-6.jpg","https://media.gemworkers.com/items/5a59f339-0922-4d1f-a76b-6208bedc8fe0/etsy-7.jpg","https://media.gemworkers.com/items/5a59f339-0922-4d1f-a76b-6208bedc8fe0/etsy-8.jpg","https://media.gemworkers.com/items/5a59f339-0922-4d1f-a76b-6208bedc8fe0/etsy-9.jpg","https://media.gemworkers.com/items/5a59f339-0922-4d1f-a76b-6208bedc8fe0/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 180 USD, converted at ECB rate. Etsy tags: Jewellery Making,Rings For Women,Jewellery Finding,Rings For Men,Jewels,Gold Rings,Jewellery Supplies,Gift For Her,Natural Stone,Blue tourmaline,lagoon Tourmaline,Oceangemsminerals,AppleGreenTourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('d89a5669-bfbd-40fa-955b-ae5e1d37b476', '1.35 Cts Indicolite Tourmaline', 'Top Indicolite Colour Tourmaline Emerald Cut 

rare find

1.35 carats 

Size:8.8x4.6x3.8mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 121, 1, 'loose_stone', 'Tourmaline', 'Indicolite', 1.35, 'ct', NULL, NULL, '8.8x4.6x3.8', '["https://media.gemworkers.com/items/d89a5669-bfbd-40fa-955b-ae5e1d37b476/etsy-1.jpg","https://media.gemworkers.com/items/d89a5669-bfbd-40fa-955b-ae5e1d37b476/etsy-2.jpg","https://media.gemworkers.com/items/d89a5669-bfbd-40fa-955b-ae5e1d37b476/etsy-3.jpg","https://media.gemworkers.com/items/d89a5669-bfbd-40fa-955b-ae5e1d37b476/etsy-4.jpg","https://media.gemworkers.com/items/d89a5669-bfbd-40fa-955b-ae5e1d37b476/etsy-5.jpg","https://media.gemworkers.com/items/d89a5669-bfbd-40fa-955b-ae5e1d37b476/etsy-6.jpg","https://media.gemworkers.com/items/d89a5669-bfbd-40fa-955b-ae5e1d37b476/etsy-7.jpg","https://media.gemworkers.com/items/d89a5669-bfbd-40fa-955b-ae5e1d37b476/etsy-8.jpg","https://media.gemworkers.com/items/d89a5669-bfbd-40fa-955b-ae5e1d37b476/etsy-9.jpg","https://media.gemworkers.com/items/d89a5669-bfbd-40fa-955b-ae5e1d37b476/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 135 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('e331ac00-fce4-43bf-8a2a-be5c6311c283', '1 Cts Neon Blue Bicolour Tourmaline', 'Top Quality Neon Blue Bicolour Tourmaline Emerald Cut 

rare find

1 carat 

Size:7.5x4.1x3.3mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 134, 1, 'loose_stone', 'Tourmaline', NULL, 1, 'ct', NULL, NULL, '7.5x4.1x3.3', '["https://media.gemworkers.com/items/e331ac00-fce4-43bf-8a2a-be5c6311c283/etsy-1.jpg","https://media.gemworkers.com/items/e331ac00-fce4-43bf-8a2a-be5c6311c283/etsy-2.jpg","https://media.gemworkers.com/items/e331ac00-fce4-43bf-8a2a-be5c6311c283/etsy-3.jpg","https://media.gemworkers.com/items/e331ac00-fce4-43bf-8a2a-be5c6311c283/etsy-4.jpg","https://media.gemworkers.com/items/e331ac00-fce4-43bf-8a2a-be5c6311c283/etsy-5.jpg","https://media.gemworkers.com/items/e331ac00-fce4-43bf-8a2a-be5c6311c283/etsy-6.jpg","https://media.gemworkers.com/items/e331ac00-fce4-43bf-8a2a-be5c6311c283/etsy-7.jpg","https://media.gemworkers.com/items/e331ac00-fce4-43bf-8a2a-be5c6311c283/etsy-8.jpg","https://media.gemworkers.com/items/e331ac00-fce4-43bf-8a2a-be5c6311c283/etsy-9.jpg","https://media.gemworkers.com/items/e331ac00-fce4-43bf-8a2a-be5c6311c283/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 150 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('06b5afae-2bea-4afd-a706-2df48af6e98a', '1.07 Cts Spinel Set', 'A Very Unique Spinel Set

1.07 Cts

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Spinel', NULL, 1.07, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/06b5afae-2bea-4afd-a706-2df48af6e98a/etsy-1.jpg","https://media.gemworkers.com/items/06b5afae-2bea-4afd-a706-2df48af6e98a/etsy-2.jpg","https://media.gemworkers.com/items/06b5afae-2bea-4afd-a706-2df48af6e98a/etsy-3.jpg","https://media.gemworkers.com/items/06b5afae-2bea-4afd-a706-2df48af6e98a/etsy-4.jpg","https://media.gemworkers.com/items/06b5afae-2bea-4afd-a706-2df48af6e98a/etsy-5.jpg","https://media.gemworkers.com/items/06b5afae-2bea-4afd-a706-2df48af6e98a/etsy-6.jpg","https://media.gemworkers.com/items/06b5afae-2bea-4afd-a706-2df48af6e98a/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Spinel Jewellery,Spinel Rings,Pink Spinel,Orange Spinel,Bicolour Spinel,Unique Spinel,Faceted Spinel,Jewellery Making,Jewellery Supplies,Oceangemsminerals,Spinel Necklace,Gift For Her,Natural Stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('ffab1561-3ca1-4589-b316-2aa1a1420edf', '10.60 Cts Unique Bicolour Tourmaline', 'Gorgeous Mesmerising Rare Bicolour Natural Afghanistan Tourmaline 

More beautiful In real, One of a kind

10.60 Cts
12.5 x 11 x 9mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 322, 1, 'loose_stone', 'Tourmaline', NULL, 10.6, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/ffab1561-3ca1-4589-b316-2aa1a1420edf/etsy-1.jpg","https://media.gemworkers.com/items/ffab1561-3ca1-4589-b316-2aa1a1420edf/etsy-2.jpg","https://media.gemworkers.com/items/ffab1561-3ca1-4589-b316-2aa1a1420edf/etsy-3.jpg","https://media.gemworkers.com/items/ffab1561-3ca1-4589-b316-2aa1a1420edf/etsy-4.jpg","https://media.gemworkers.com/items/ffab1561-3ca1-4589-b316-2aa1a1420edf/etsy-5.jpg","https://media.gemworkers.com/items/ffab1561-3ca1-4589-b316-2aa1a1420edf/etsy-6.jpg","https://media.gemworkers.com/items/ffab1561-3ca1-4589-b316-2aa1a1420edf/etsy-7.jpg","https://media.gemworkers.com/items/ffab1561-3ca1-4589-b316-2aa1a1420edf/etsy-8.jpg","https://media.gemworkers.com/items/ffab1561-3ca1-4589-b316-2aa1a1420edf/etsy-9.jpg","https://media.gemworkers.com/items/ffab1561-3ca1-4589-b316-2aa1a1420edf/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 360 USD, converted at ECB rate. Etsy tags: Gold Rings,Rings For Men,Rings For Women,Gift For Her,Tourmaline Jewellery,Natural Stone,bicolour Tourmaline,Lagoon tourmaline,Bluegreen tourmaline,blue tourmaline,indigo tourmaline,Oceangemsminerals,rare tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('738c4354-a1e5-4d88-90d7-9075bf4ea5db', '10.60 Cts Lagoon Bicolour Tourmaline.', 'Gorgeous Mesmerising Rare Bicolour Natural Afghanistan Tourmaline 

More beautiful In real, One of a kind

10.60 Cts
15 x 10.5 x 8mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 447, 1, 'loose_stone', 'Tourmaline', NULL, 10.6, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/738c4354-a1e5-4d88-90d7-9075bf4ea5db/etsy-1.jpg","https://media.gemworkers.com/items/738c4354-a1e5-4d88-90d7-9075bf4ea5db/etsy-2.jpg","https://media.gemworkers.com/items/738c4354-a1e5-4d88-90d7-9075bf4ea5db/etsy-3.jpg","https://media.gemworkers.com/items/738c4354-a1e5-4d88-90d7-9075bf4ea5db/etsy-4.jpg","https://media.gemworkers.com/items/738c4354-a1e5-4d88-90d7-9075bf4ea5db/etsy-5.jpg","https://media.gemworkers.com/items/738c4354-a1e5-4d88-90d7-9075bf4ea5db/etsy-6.jpg","https://media.gemworkers.com/items/738c4354-a1e5-4d88-90d7-9075bf4ea5db/etsy-7.jpg","https://media.gemworkers.com/items/738c4354-a1e5-4d88-90d7-9075bf4ea5db/etsy-8.jpg","https://media.gemworkers.com/items/738c4354-a1e5-4d88-90d7-9075bf4ea5db/etsy-9.jpg","https://media.gemworkers.com/items/738c4354-a1e5-4d88-90d7-9075bf4ea5db/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 500 USD, converted at ECB rate. Etsy tags: Gold Rings,Rings For Men,Rings For Women,Gift For Her,Tourmaline Jewellery,Natural Stone,bicolour Tourmaline,Lagoon tourmaline,Bluegreen tourmaline,blue tourmaline,indigo tourmaline,Oceangemsminerals,rare tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('5d440bd9-edd3-463a-b481-706543585bae', '4.90 Cts Lagoon Bicolour Tourmaline,', 'Gorgeous Mesmerising Rare Bicolour Natural Afghanistan Tourmaline 

More beautiful In real, One of a kind

4.90 Cts
9 x 6 x 4.5mm
10 x 6 x 5mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 4.9, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/5d440bd9-edd3-463a-b481-706543585bae/etsy-1.jpg","https://media.gemworkers.com/items/5d440bd9-edd3-463a-b481-706543585bae/etsy-2.jpg","https://media.gemworkers.com/items/5d440bd9-edd3-463a-b481-706543585bae/etsy-3.jpg","https://media.gemworkers.com/items/5d440bd9-edd3-463a-b481-706543585bae/etsy-4.jpg","https://media.gemworkers.com/items/5d440bd9-edd3-463a-b481-706543585bae/etsy-5.jpg","https://media.gemworkers.com/items/5d440bd9-edd3-463a-b481-706543585bae/etsy-6.jpg","https://media.gemworkers.com/items/5d440bd9-edd3-463a-b481-706543585bae/etsy-7.jpg","https://media.gemworkers.com/items/5d440bd9-edd3-463a-b481-706543585bae/etsy-8.jpg","https://media.gemworkers.com/items/5d440bd9-edd3-463a-b481-706543585bae/etsy-9.jpg","https://media.gemworkers.com/items/5d440bd9-edd3-463a-b481-706543585bae/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Gold Rings,Rings For Men,Rings For Women,Gift For Her,Tourmaline Jewellery,Natural Stone,bicolour Tourmaline,Lagoon tourmaline,Bluegreen tourmaline,blue tourmaline,indigo tourmaline,Oceangemsminerals,rare tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('e23e68f9-734f-4d60-acd2-e01fc7fca08a', '1.75 Cts Watermelon Bicolour Tourmaline', 'Top Quality Natural Watermelon Bicolour Tourmaline Emerald Cut 

Rare find, High Lustre, Top Polish

Glowing And Sweet Stone

1.75 Cts
18.4 x 3.1 x 3.1mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 348, 1, 'loose_stone', 'Tourmaline', 'Watermelon', 1.75, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/e23e68f9-734f-4d60-acd2-e01fc7fca08a/etsy-1.jpg","https://media.gemworkers.com/items/e23e68f9-734f-4d60-acd2-e01fc7fca08a/etsy-2.jpg","https://media.gemworkers.com/items/e23e68f9-734f-4d60-acd2-e01fc7fca08a/etsy-3.jpg","https://media.gemworkers.com/items/e23e68f9-734f-4d60-acd2-e01fc7fca08a/etsy-4.jpg","https://media.gemworkers.com/items/e23e68f9-734f-4d60-acd2-e01fc7fca08a/etsy-5.jpg","https://media.gemworkers.com/items/e23e68f9-734f-4d60-acd2-e01fc7fca08a/etsy-6.jpg","https://media.gemworkers.com/items/e23e68f9-734f-4d60-acd2-e01fc7fca08a/etsy-7.jpg","https://media.gemworkers.com/items/e23e68f9-734f-4d60-acd2-e01fc7fca08a/etsy-8.jpg","https://media.gemworkers.com/items/e23e68f9-734f-4d60-acd2-e01fc7fca08a/etsy-9.jpg","https://media.gemworkers.com/items/e23e68f9-734f-4d60-acd2-e01fc7fca08a/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 390 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('41b306d3-0d4a-404a-abd9-415e778805f1', '2 Cts Apple Green Tourmaline Pair', 'Mesmerising Apple 🍏 Green Colour Afghan Tourmaline Pair

Ethically Sourced, Eye Clean

high lustre and brilliance 

2 Cts
7.2 x 4.3 x 3.6mm

Unheated, No treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 161, 1, 'loose_stone', 'Tourmaline', NULL, 2, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/41b306d3-0d4a-404a-abd9-415e778805f1/etsy-1.jpg","https://media.gemworkers.com/items/41b306d3-0d4a-404a-abd9-415e778805f1/etsy-2.jpg","https://media.gemworkers.com/items/41b306d3-0d4a-404a-abd9-415e778805f1/etsy-3.jpg","https://media.gemworkers.com/items/41b306d3-0d4a-404a-abd9-415e778805f1/etsy-4.jpg","https://media.gemworkers.com/items/41b306d3-0d4a-404a-abd9-415e778805f1/etsy-5.jpg","https://media.gemworkers.com/items/41b306d3-0d4a-404a-abd9-415e778805f1/etsy-6.jpg","https://media.gemworkers.com/items/41b306d3-0d4a-404a-abd9-415e778805f1/etsy-7.jpg","https://media.gemworkers.com/items/41b306d3-0d4a-404a-abd9-415e778805f1/etsy-8.jpg","https://media.gemworkers.com/items/41b306d3-0d4a-404a-abd9-415e778805f1/etsy-9.jpg","https://media.gemworkers.com/items/41b306d3-0d4a-404a-abd9-415e778805f1/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 180 USD, converted at ECB rate. Etsy tags: Jewellery Making,Rings For Women,Jewellery Finding,Rings For Men,Jewels,Gold Rings,Jewellery Supplies,Gift For Her,Natural Stone,Blue tourmaline,lagoon Tourmaline,Oceangemsminerals,AppleGreenTourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('20c005cc-fbef-425d-9744-6581e3baca6e', '1.01 Cts Spinel Set', 'A Very Unique Spinel Set

1.07 Cts

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Spinel', NULL, 1.01, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/20c005cc-fbef-425d-9744-6581e3baca6e/etsy-1.jpg","https://media.gemworkers.com/items/20c005cc-fbef-425d-9744-6581e3baca6e/etsy-2.jpg","https://media.gemworkers.com/items/20c005cc-fbef-425d-9744-6581e3baca6e/etsy-3.jpg","https://media.gemworkers.com/items/20c005cc-fbef-425d-9744-6581e3baca6e/etsy-4.jpg","https://media.gemworkers.com/items/20c005cc-fbef-425d-9744-6581e3baca6e/etsy-5.jpg","https://media.gemworkers.com/items/20c005cc-fbef-425d-9744-6581e3baca6e/etsy-6.jpg","https://media.gemworkers.com/items/20c005cc-fbef-425d-9744-6581e3baca6e/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Spinel Jewellery,Spinel Rings,Pink Spinel,Orange Spinel,Bicolour Spinel,Unique Spinel,Faceted Spinel,Jewellery Making,Jewellery Supplies,Oceangemsminerals,Spinel Necklace,Gift For Her,Natural Stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('57c1d6a5-b8a4-4b4a-bc26-ce628b53669e', '10.15 Cts Tricolour Afghan Tourmalines', 'Natural Tricolour Afghan mesmerising tourmaline 

Unique Colour Combination 

2 stones
1 Mismatched Pair

10.15 Cts
10.8x6.7x4.3mm 
10.9x6.8x5.4mm
7x5.6x4.4mm

unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 295, 1, 'loose_stone', 'Tourmaline', NULL, 10.15, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/57c1d6a5-b8a4-4b4a-bc26-ce628b53669e/etsy-1.jpg","https://media.gemworkers.com/items/57c1d6a5-b8a4-4b4a-bc26-ce628b53669e/etsy-2.jpg","https://media.gemworkers.com/items/57c1d6a5-b8a4-4b4a-bc26-ce628b53669e/etsy-3.jpg","https://media.gemworkers.com/items/57c1d6a5-b8a4-4b4a-bc26-ce628b53669e/etsy-4.jpg","https://media.gemworkers.com/items/57c1d6a5-b8a4-4b4a-bc26-ce628b53669e/etsy-5.jpg","https://media.gemworkers.com/items/57c1d6a5-b8a4-4b4a-bc26-ce628b53669e/etsy-6.jpg","https://media.gemworkers.com/items/57c1d6a5-b8a4-4b4a-bc26-ce628b53669e/etsy-7.jpg","https://media.gemworkers.com/items/57c1d6a5-b8a4-4b4a-bc26-ce628b53669e/etsy-8.jpg","https://media.gemworkers.com/items/57c1d6a5-b8a4-4b4a-bc26-ce628b53669e/etsy-9.jpg","https://media.gemworkers.com/items/57c1d6a5-b8a4-4b4a-bc26-ce628b53669e/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 330 USD, converted at ECB rate. Etsy tags: Rings for women,rings for men,natural stone,gift for her,jewellery making,jewellery supplies,jewellery findings,bicolour tourmaline,pink tourmaline,stud jewellery,tourmaline emerald,emerald cut,green tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('35f1d8e2-63b1-48f2-920b-eabfa26b20e9', '0.7 Cts Hot Pink Tourmaline', 'Gorgeous Hot Pink Tourmaline best for ring 💍 

Perfectly Cut

0.7 Cts
5.2 x 4 x 3.3mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 0.7, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/35f1d8e2-63b1-48f2-920b-eabfa26b20e9/etsy-1.jpg","https://media.gemworkers.com/items/35f1d8e2-63b1-48f2-920b-eabfa26b20e9/etsy-2.jpg","https://media.gemworkers.com/items/35f1d8e2-63b1-48f2-920b-eabfa26b20e9/etsy-3.jpg","https://media.gemworkers.com/items/35f1d8e2-63b1-48f2-920b-eabfa26b20e9/etsy-4.jpg","https://media.gemworkers.com/items/35f1d8e2-63b1-48f2-920b-eabfa26b20e9/etsy-5.jpg","https://media.gemworkers.com/items/35f1d8e2-63b1-48f2-920b-eabfa26b20e9/etsy-6.jpg","https://media.gemworkers.com/items/35f1d8e2-63b1-48f2-920b-eabfa26b20e9/etsy-7.jpg","https://media.gemworkers.com/items/35f1d8e2-63b1-48f2-920b-eabfa26b20e9/etsy-8.jpg","https://media.gemworkers.com/items/35f1d8e2-63b1-48f2-920b-eabfa26b20e9/etsy-9.jpg","https://media.gemworkers.com/items/35f1d8e2-63b1-48f2-920b-eabfa26b20e9/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('cb625131-48be-422c-ac0a-8420ad992917', '4.35 Cts Pink Tourmaline Pairs', 'Gorgeous Pink Tourmaline Pairs 

Perfect For Earrings 

4.35 Cts
8.9 x 4.6 x 3.8mm
4.8 x 4.6 x 3.8m

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 402, 1, 'loose_stone', 'Tourmaline', NULL, 4.35, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/cb625131-48be-422c-ac0a-8420ad992917/etsy-1.jpg","https://media.gemworkers.com/items/cb625131-48be-422c-ac0a-8420ad992917/etsy-2.jpg","https://media.gemworkers.com/items/cb625131-48be-422c-ac0a-8420ad992917/etsy-3.jpg","https://media.gemworkers.com/items/cb625131-48be-422c-ac0a-8420ad992917/etsy-4.jpg","https://media.gemworkers.com/items/cb625131-48be-422c-ac0a-8420ad992917/etsy-5.jpg","https://media.gemworkers.com/items/cb625131-48be-422c-ac0a-8420ad992917/etsy-6.jpg","https://media.gemworkers.com/items/cb625131-48be-422c-ac0a-8420ad992917/etsy-7.jpg","https://media.gemworkers.com/items/cb625131-48be-422c-ac0a-8420ad992917/etsy-8.jpg","https://media.gemworkers.com/items/cb625131-48be-422c-ac0a-8420ad992917/etsy-9.jpg","https://media.gemworkers.com/items/cb625131-48be-422c-ac0a-8420ad992917/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 450 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,jewels,Handmadejewellery,gift for her,Topqualitytourmaline,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('c2df17ad-80c5-4bd4-833a-cadd8f238c75', '3.4 Cts Mix Colour Tourmaline Lot', 'Gorgeous Mesmerising Afghan Tourmaline lot,

Unique Colour, glossy and high lustre.

best for jewellery 

3.40 Cts
8 to 4.3mm

Clarity: Eye Clean And Loupe Clean

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 205, 1, 'loose_stone', 'Tourmaline', NULL, 3.4, 'ct', 'Afghanistan', 'Eye Clean And Loupe Clean', NULL, '["https://media.gemworkers.com/items/c2df17ad-80c5-4bd4-833a-cadd8f238c75/etsy-1.jpg","https://media.gemworkers.com/items/c2df17ad-80c5-4bd4-833a-cadd8f238c75/etsy-2.jpg","https://media.gemworkers.com/items/c2df17ad-80c5-4bd4-833a-cadd8f238c75/etsy-3.jpg","https://media.gemworkers.com/items/c2df17ad-80c5-4bd4-833a-cadd8f238c75/etsy-4.jpg","https://media.gemworkers.com/items/c2df17ad-80c5-4bd4-833a-cadd8f238c75/etsy-5.jpg","https://media.gemworkers.com/items/c2df17ad-80c5-4bd4-833a-cadd8f238c75/etsy-6.jpg","https://media.gemworkers.com/items/c2df17ad-80c5-4bd4-833a-cadd8f238c75/etsy-7.jpg","https://media.gemworkers.com/items/c2df17ad-80c5-4bd4-833a-cadd8f238c75/etsy-8.jpg","https://media.gemworkers.com/items/c2df17ad-80c5-4bd4-833a-cadd8f238c75/etsy-9.jpg","https://media.gemworkers.com/items/c2df17ad-80c5-4bd4-833a-cadd8f238c75/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 230 USD, converted at ECB rate. Etsy tags: BlueGreen Tourmaline,Blue Tourmaline,Green Tourmaline,Lagoon Tourmaline,Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery findings,gift for her,natural stone,Oceangemsminerals,apple green colour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('c05244cf-4703-4c47-be53-a4849e8173e8', '12.85 Cts Jewellery Size Tourmaline lot', 'Gorgeous Mix Colour Calibrated Size Tourmaline Lot

12.85 Cts
6.5 to 5.1mm

round cut, lustre and brilliance.

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'jewelry', 'Tourmaline', NULL, 12.85, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/c05244cf-4703-4c47-be53-a4849e8173e8/etsy-1.jpg","https://media.gemworkers.com/items/c05244cf-4703-4c47-be53-a4849e8173e8/etsy-2.jpg","https://media.gemworkers.com/items/c05244cf-4703-4c47-be53-a4849e8173e8/etsy-3.jpg","https://media.gemworkers.com/items/c05244cf-4703-4c47-be53-a4849e8173e8/etsy-4.jpg","https://media.gemworkers.com/items/c05244cf-4703-4c47-be53-a4849e8173e8/etsy-5.jpg","https://media.gemworkers.com/items/c05244cf-4703-4c47-be53-a4849e8173e8/etsy-6.jpg","https://media.gemworkers.com/items/c05244cf-4703-4c47-be53-a4849e8173e8/etsy-7.jpg","https://media.gemworkers.com/items/c05244cf-4703-4c47-be53-a4849e8173e8/etsy-8.jpg","https://media.gemworkers.com/items/c05244cf-4703-4c47-be53-a4849e8173e8/etsy-9.jpg","https://media.gemworkers.com/items/c05244cf-4703-4c47-be53-a4849e8173e8/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Loose gemstones,jewellery making,jewellery supplies,jewellery findings,gift for her,natural stone,y2k earrings stud,jewels,Handmadejewellery,CalibratedTourmaline,Tourmaline Jewellery,Jewellery Size,Tourmaline Lot.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('3d49e5cf-8e6d-405a-8853-bb9291616d0c', '8.65 Cts Jewellery Size Tourmaline lot', 'Gorgeous Pure Hot Pink Colour Calibrated Size Tourmaline Lot

8.65 Cts
4.8 to 3.9mm

round cut, lustre and brilliance.

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 161, 1, 'jewelry', 'Tourmaline', NULL, 8.65, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/3d49e5cf-8e6d-405a-8853-bb9291616d0c/etsy-1.jpg","https://media.gemworkers.com/items/3d49e5cf-8e6d-405a-8853-bb9291616d0c/etsy-2.jpg","https://media.gemworkers.com/items/3d49e5cf-8e6d-405a-8853-bb9291616d0c/etsy-3.jpg","https://media.gemworkers.com/items/3d49e5cf-8e6d-405a-8853-bb9291616d0c/etsy-4.jpg","https://media.gemworkers.com/items/3d49e5cf-8e6d-405a-8853-bb9291616d0c/etsy-5.jpg","https://media.gemworkers.com/items/3d49e5cf-8e6d-405a-8853-bb9291616d0c/etsy-6.jpg","https://media.gemworkers.com/items/3d49e5cf-8e6d-405a-8853-bb9291616d0c/etsy-7.jpg","https://media.gemworkers.com/items/3d49e5cf-8e6d-405a-8853-bb9291616d0c/etsy-8.jpg","https://media.gemworkers.com/items/3d49e5cf-8e6d-405a-8853-bb9291616d0c/etsy-9.jpg","https://media.gemworkers.com/items/3d49e5cf-8e6d-405a-8853-bb9291616d0c/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 180 USD, converted at ECB rate. Etsy tags: Loose gemstones,jewellery making,jewellery supplies,jewellery findings,gift for her,natural stone,y2k earrings stud,jewels,Handmadejewellery,CalibratedTourmaline,Tourmaline Jewellery,Jewellery Size,Tourmaline Lot.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('130253a6-f162-4bea-8fe4-69f898f16628', '9.30 Cts Jewellery Size Tourmaline lot', 'Gorgeous Mix Colour Calibrated Size Tourmaline Lot

9.30 Cts
5.1 to 3.4mm

round cut, lustre and brilliance.

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 161, 1, 'jewelry', 'Tourmaline', NULL, 9.3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/130253a6-f162-4bea-8fe4-69f898f16628/etsy-1.jpg","https://media.gemworkers.com/items/130253a6-f162-4bea-8fe4-69f898f16628/etsy-2.jpg","https://media.gemworkers.com/items/130253a6-f162-4bea-8fe4-69f898f16628/etsy-3.jpg","https://media.gemworkers.com/items/130253a6-f162-4bea-8fe4-69f898f16628/etsy-4.jpg","https://media.gemworkers.com/items/130253a6-f162-4bea-8fe4-69f898f16628/etsy-5.jpg","https://media.gemworkers.com/items/130253a6-f162-4bea-8fe4-69f898f16628/etsy-6.jpg","https://media.gemworkers.com/items/130253a6-f162-4bea-8fe4-69f898f16628/etsy-7.jpg","https://media.gemworkers.com/items/130253a6-f162-4bea-8fe4-69f898f16628/etsy-8.jpg","https://media.gemworkers.com/items/130253a6-f162-4bea-8fe4-69f898f16628/etsy-9.jpg","https://media.gemworkers.com/items/130253a6-f162-4bea-8fe4-69f898f16628/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 180 USD, converted at ECB rate. Etsy tags: Loose gemstones,jewellery making,jewellery supplies,jewellery findings,gift for her,natural stone,y2k earrings stud,jewels,Handmadejewellery,CalibratedTourmaline,Tourmaline Jewellery,Jewellery Size,Tourmaline Lot.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('e60483f0-a426-47e9-9f8c-c0b0136a21b0', '4.00 Cts Special Bicolour Tourmaline', 'Sweet Perfect Bicolour Tourmaline 

Unique And Rare Colour

Very Shiny And High Lustre 

4.00 Cts
9.5 x 5 x 4mm

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 715, 1, 'loose_stone', 'Tourmaline', NULL, 4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/e60483f0-a426-47e9-9f8c-c0b0136a21b0/etsy-1.jpg","https://media.gemworkers.com/items/e60483f0-a426-47e9-9f8c-c0b0136a21b0/etsy-2.jpg","https://media.gemworkers.com/items/e60483f0-a426-47e9-9f8c-c0b0136a21b0/etsy-3.jpg","https://media.gemworkers.com/items/e60483f0-a426-47e9-9f8c-c0b0136a21b0/etsy-4.jpg","https://media.gemworkers.com/items/e60483f0-a426-47e9-9f8c-c0b0136a21b0/etsy-5.jpg","https://media.gemworkers.com/items/e60483f0-a426-47e9-9f8c-c0b0136a21b0/etsy-6.jpg","https://media.gemworkers.com/items/e60483f0-a426-47e9-9f8c-c0b0136a21b0/etsy-7.jpg","https://media.gemworkers.com/items/e60483f0-a426-47e9-9f8c-c0b0136a21b0/etsy-8.jpg","https://media.gemworkers.com/items/e60483f0-a426-47e9-9f8c-c0b0136a21b0/etsy-9.jpg","https://media.gemworkers.com/items/e60483f0-a426-47e9-9f8c-c0b0136a21b0/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 800 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Oceangemsminerals,lagoon tourmaline,tourmaline pairs,bicolour tourmaline,Watermelon Bicolour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('3853572b-46ee-447b-9a0d-c892acc49e82', '2.6 Cts Special Bicolour Tourmaline', 'Sweet Perfect Bicolour Tourmaline 

Unique And Rare Colour

Very Shiny And High Lustre 

2.60 cts
9.6 x 3.5 x 2.9mm

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 535, 1, 'loose_stone', 'Tourmaline', NULL, 2.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/3853572b-46ee-447b-9a0d-c892acc49e82/etsy-1.jpg","https://media.gemworkers.com/items/3853572b-46ee-447b-9a0d-c892acc49e82/etsy-2.jpg","https://media.gemworkers.com/items/3853572b-46ee-447b-9a0d-c892acc49e82/etsy-3.jpg","https://media.gemworkers.com/items/3853572b-46ee-447b-9a0d-c892acc49e82/etsy-4.jpg","https://media.gemworkers.com/items/3853572b-46ee-447b-9a0d-c892acc49e82/etsy-5.jpg","https://media.gemworkers.com/items/3853572b-46ee-447b-9a0d-c892acc49e82/etsy-6.jpg","https://media.gemworkers.com/items/3853572b-46ee-447b-9a0d-c892acc49e82/etsy-7.jpg","https://media.gemworkers.com/items/3853572b-46ee-447b-9a0d-c892acc49e82/etsy-8.jpg","https://media.gemworkers.com/items/3853572b-46ee-447b-9a0d-c892acc49e82/etsy-9.jpg","https://media.gemworkers.com/items/3853572b-46ee-447b-9a0d-c892acc49e82/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 599 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Oceangemsminerals,lagoon tourmaline,tourmaline pairs,bicolour tourmaline,Watermelon Bicolour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('f2419e26-240d-495e-bd8c-f64bfa5c8238', 'Watermelon Tourmaline Gemstone: Rare Color, High Lustre, (2.00 Cts)', 'Sweet Perfect Watermelon Tourmaline 

Unique And Rare Colour

Very Shiny And High Lustre 

2.00 Cts
6.3 x 3.7 x 3.3mm

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 535, 1, 'loose_stone', 'Tourmaline', 'Watermelon', 2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/f2419e26-240d-495e-bd8c-f64bfa5c8238/etsy-1.jpg","https://media.gemworkers.com/items/f2419e26-240d-495e-bd8c-f64bfa5c8238/etsy-2.jpg","https://media.gemworkers.com/items/f2419e26-240d-495e-bd8c-f64bfa5c8238/etsy-3.jpg","https://media.gemworkers.com/items/f2419e26-240d-495e-bd8c-f64bfa5c8238/etsy-4.jpg","https://media.gemworkers.com/items/f2419e26-240d-495e-bd8c-f64bfa5c8238/etsy-5.jpg","https://media.gemworkers.com/items/f2419e26-240d-495e-bd8c-f64bfa5c8238/etsy-6.jpg","https://media.gemworkers.com/items/f2419e26-240d-495e-bd8c-f64bfa5c8238/etsy-7.jpg","https://media.gemworkers.com/items/f2419e26-240d-495e-bd8c-f64bfa5c8238/etsy-8.jpg","https://media.gemworkers.com/items/f2419e26-240d-495e-bd8c-f64bfa5c8238/etsy-9.jpg","https://media.gemworkers.com/items/f2419e26-240d-495e-bd8c-f64bfa5c8238/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 599 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Oceangemsminerals,lagoon tourmaline,tourmaline pairs,bicolour tourmaline,Watermelon Bicolour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('eb21680f-f7d3-4c73-8210-455dfd2f5988', 'Watermelon Tourmaline Gemstone: Rare Color, High Lustre, (1.95 Cts)', 'Sweet Perfect Watermelon Tourmaline 

Unique And Rare Colour

Very Shiny And High Lustre 

1.95 Cts
5.6 x 4.9 x 3.4mm

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 446, 1, 'loose_stone', 'Tourmaline', 'Watermelon', 1.95, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/eb21680f-f7d3-4c73-8210-455dfd2f5988/etsy-1.jpg","https://media.gemworkers.com/items/eb21680f-f7d3-4c73-8210-455dfd2f5988/etsy-2.jpg","https://media.gemworkers.com/items/eb21680f-f7d3-4c73-8210-455dfd2f5988/etsy-3.jpg","https://media.gemworkers.com/items/eb21680f-f7d3-4c73-8210-455dfd2f5988/etsy-4.jpg","https://media.gemworkers.com/items/eb21680f-f7d3-4c73-8210-455dfd2f5988/etsy-5.jpg","https://media.gemworkers.com/items/eb21680f-f7d3-4c73-8210-455dfd2f5988/etsy-6.jpg","https://media.gemworkers.com/items/eb21680f-f7d3-4c73-8210-455dfd2f5988/etsy-7.jpg","https://media.gemworkers.com/items/eb21680f-f7d3-4c73-8210-455dfd2f5988/etsy-8.jpg","https://media.gemworkers.com/items/eb21680f-f7d3-4c73-8210-455dfd2f5988/etsy-9.jpg","https://media.gemworkers.com/items/eb21680f-f7d3-4c73-8210-455dfd2f5988/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 499 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Oceangemsminerals,lagoon tourmaline,tourmaline pairs,bicolour tourmaline,Watermelon Bicolour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('4190e32b-929a-40fe-b3f7-8de5c6220e5b', 'Watermelon Tourmaline Gemstone: Rare Color, High Lustre, (0.60 Cts)', 'Sweet Perfect Watermelon Tourmaline 

Unique And Rare Colour

Very Shiny And High Lustre 

0.60 Cts
3.4 x 2.2 x 1.7mmi

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', 'Watermelon', 0.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/4190e32b-929a-40fe-b3f7-8de5c6220e5b/etsy-1.jpg","https://media.gemworkers.com/items/4190e32b-929a-40fe-b3f7-8de5c6220e5b/etsy-2.jpg","https://media.gemworkers.com/items/4190e32b-929a-40fe-b3f7-8de5c6220e5b/etsy-3.jpg","https://media.gemworkers.com/items/4190e32b-929a-40fe-b3f7-8de5c6220e5b/etsy-4.jpg","https://media.gemworkers.com/items/4190e32b-929a-40fe-b3f7-8de5c6220e5b/etsy-5.jpg","https://media.gemworkers.com/items/4190e32b-929a-40fe-b3f7-8de5c6220e5b/etsy-6.jpg","https://media.gemworkers.com/items/4190e32b-929a-40fe-b3f7-8de5c6220e5b/etsy-7.jpg","https://media.gemworkers.com/items/4190e32b-929a-40fe-b3f7-8de5c6220e5b/etsy-8.jpg","https://media.gemworkers.com/items/4190e32b-929a-40fe-b3f7-8de5c6220e5b/etsy-9.jpg","https://media.gemworkers.com/items/4190e32b-929a-40fe-b3f7-8de5c6220e5b/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Oceangemsminerals,lagoon tourmaline,tourmaline pairs,bicolour tourmaline,Watermelon Bicolour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('5c9906a4-575a-4213-ae87-7119598c241b', '1.05 Cts Hot Pink Tourmaline', 'Gorgeous Hot Pink Tourmaline best for ring 💍 

Perfectly Cut

1.05 Cts
4 x 3.8 x 2.5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 313, 1, 'loose_stone', 'Tourmaline', NULL, 1.05, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/5c9906a4-575a-4213-ae87-7119598c241b/etsy-1.jpg","https://media.gemworkers.com/items/5c9906a4-575a-4213-ae87-7119598c241b/etsy-2.jpg","https://media.gemworkers.com/items/5c9906a4-575a-4213-ae87-7119598c241b/etsy-3.jpg","https://media.gemworkers.com/items/5c9906a4-575a-4213-ae87-7119598c241b/etsy-4.jpg","https://media.gemworkers.com/items/5c9906a4-575a-4213-ae87-7119598c241b/etsy-5.jpg","https://media.gemworkers.com/items/5c9906a4-575a-4213-ae87-7119598c241b/etsy-6.jpg","https://media.gemworkers.com/items/5c9906a4-575a-4213-ae87-7119598c241b/etsy-7.jpg","https://media.gemworkers.com/items/5c9906a4-575a-4213-ae87-7119598c241b/etsy-8.jpg","https://media.gemworkers.com/items/5c9906a4-575a-4213-ae87-7119598c241b/etsy-9.jpg","https://media.gemworkers.com/items/5c9906a4-575a-4213-ae87-7119598c241b/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 350 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('afe024b8-e5e6-4dfb-8bfd-4d5eb6208cf0', '0.7 Cts Hot Pink Tourmaline', 'Gorgeous Hot Pink Tourmaline best for ring 💍 

Perfectly Cut

0.70 Cts
3 x 2.8 x 2.2mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 0.7, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/afe024b8-e5e6-4dfb-8bfd-4d5eb6208cf0/etsy-1.jpg","https://media.gemworkers.com/items/afe024b8-e5e6-4dfb-8bfd-4d5eb6208cf0/etsy-2.jpg","https://media.gemworkers.com/items/afe024b8-e5e6-4dfb-8bfd-4d5eb6208cf0/etsy-3.jpg","https://media.gemworkers.com/items/afe024b8-e5e6-4dfb-8bfd-4d5eb6208cf0/etsy-4.jpg","https://media.gemworkers.com/items/afe024b8-e5e6-4dfb-8bfd-4d5eb6208cf0/etsy-5.jpg","https://media.gemworkers.com/items/afe024b8-e5e6-4dfb-8bfd-4d5eb6208cf0/etsy-6.jpg","https://media.gemworkers.com/items/afe024b8-e5e6-4dfb-8bfd-4d5eb6208cf0/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('cad9b30c-4276-4752-9d73-61c743bda484', '6.60 Cts Tourmaline Lot', 'Mix Green Colour tourmaline lot
for jewellery use

6.60 Cts
8.3 to 5.1mm

no treatment', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 125, 1, 'loose_stone', 'Tourmaline', NULL, 6.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/cad9b30c-4276-4752-9d73-61c743bda484/etsy-1.jpg","https://media.gemworkers.com/items/cad9b30c-4276-4752-9d73-61c743bda484/etsy-2.jpg","https://media.gemworkers.com/items/cad9b30c-4276-4752-9d73-61c743bda484/etsy-3.jpg","https://media.gemworkers.com/items/cad9b30c-4276-4752-9d73-61c743bda484/etsy-4.jpg","https://media.gemworkers.com/items/cad9b30c-4276-4752-9d73-61c743bda484/etsy-5.jpg","https://media.gemworkers.com/items/cad9b30c-4276-4752-9d73-61c743bda484/etsy-6.jpg","https://media.gemworkers.com/items/cad9b30c-4276-4752-9d73-61c743bda484/etsy-7.jpg","https://media.gemworkers.com/items/cad9b30c-4276-4752-9d73-61c743bda484/etsy-8.jpg","https://media.gemworkers.com/items/cad9b30c-4276-4752-9d73-61c743bda484/etsy-9.jpg","https://media.gemworkers.com/items/cad9b30c-4276-4752-9d73-61c743bda484/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 140 USD, converted at ECB rate. Etsy tags: loose gemstones,tourmaline jewellery,tourmaline lots,green tourmaline,jewellery making,jewellery supplies,jewellery findings,gift for her,natural stone,emerald cut,mint Green tourmalin,y2k earrings stud,blue tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('72ee2354-5332-472c-bf69-f557e39b3afd', '1.40 Cts Gold Colour Tourmaline', 'A Very Unique Pure Gold  Colour Tourmaline Pair

Gorgeous, Lustre And Brilliance 

1.40 Cts
5 x 5 x 3.7mm

Unheated,Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 1.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/72ee2354-5332-472c-bf69-f557e39b3afd/etsy-1.jpg","https://media.gemworkers.com/items/72ee2354-5332-472c-bf69-f557e39b3afd/etsy-2.jpg","https://media.gemworkers.com/items/72ee2354-5332-472c-bf69-f557e39b3afd/etsy-3.jpg","https://media.gemworkers.com/items/72ee2354-5332-472c-bf69-f557e39b3afd/etsy-4.jpg","https://media.gemworkers.com/items/72ee2354-5332-472c-bf69-f557e39b3afd/etsy-5.jpg","https://media.gemworkers.com/items/72ee2354-5332-472c-bf69-f557e39b3afd/etsy-6.jpg","https://media.gemworkers.com/items/72ee2354-5332-472c-bf69-f557e39b3afd/etsy-7.jpg","https://media.gemworkers.com/items/72ee2354-5332-472c-bf69-f557e39b3afd/etsy-8.jpg","https://media.gemworkers.com/items/72ee2354-5332-472c-bf69-f557e39b3afd/etsy-9.jpg","https://media.gemworkers.com/items/72ee2354-5332-472c-bf69-f557e39b3afd/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Sunset Tourmaline,Yellow Tourmaline,Bicolour Tourmaline,Tourmaline Rings,Tourmaline Jewellery,Unique Bicolour,Unique Tourmaline,Rings For Men,Rings For Women,Handmade Jewellery,Jewellery Findings,Tourmaline Pair.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('4873d648-6b57-4a0f-aa06-d35f2b83ee1f', '6.6 Cts Blue Green Tourmaline', 'Top Quality Blue Green Tourmaline 

Glossy And High Lustre

6.60 Cts
11 x 11 x 6.8mm

Unheated, No treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 339, 1, 'loose_stone', 'Tourmaline', NULL, 6.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/4873d648-6b57-4a0f-aa06-d35f2b83ee1f/etsy-1.jpg","https://media.gemworkers.com/items/4873d648-6b57-4a0f-aa06-d35f2b83ee1f/etsy-2.jpg","https://media.gemworkers.com/items/4873d648-6b57-4a0f-aa06-d35f2b83ee1f/etsy-3.jpg","https://media.gemworkers.com/items/4873d648-6b57-4a0f-aa06-d35f2b83ee1f/etsy-4.jpg","https://media.gemworkers.com/items/4873d648-6b57-4a0f-aa06-d35f2b83ee1f/etsy-5.jpg","https://media.gemworkers.com/items/4873d648-6b57-4a0f-aa06-d35f2b83ee1f/etsy-6.jpg","https://media.gemworkers.com/items/4873d648-6b57-4a0f-aa06-d35f2b83ee1f/etsy-7.jpg","https://media.gemworkers.com/items/4873d648-6b57-4a0f-aa06-d35f2b83ee1f/etsy-8.jpg","https://media.gemworkers.com/items/4873d648-6b57-4a0f-aa06-d35f2b83ee1f/etsy-9.jpg","https://media.gemworkers.com/items/4873d648-6b57-4a0f-aa06-d35f2b83ee1f/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 380 USD, converted at ECB rate. Etsy tags: Jewellery Making,Rings For Women,Rings For Men,Gold Rings,Jewellery Supplies,Gift For Her,Natural Stone,Bluegreen Tourmaline,Blue tourmaline,lagoon Tourmaline,MintGreen Tourmaline,Oceangemsminerals,Green Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('9c7d7d92-f73c-49ff-9081-e4e54d70fef2', '6.6 Cts blue and Green Tourmaline Lot', 'Blue and Green Afghan Tourmaline Lot 

High Lustre And Good Colours.

6.60 Cts
11.4 to 5.1mm

Unheated,Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 356, 1, 'loose_stone', 'Tourmaline', NULL, 6.6, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/9c7d7d92-f73c-49ff-9081-e4e54d70fef2/etsy-1.jpg","https://media.gemworkers.com/items/9c7d7d92-f73c-49ff-9081-e4e54d70fef2/etsy-2.jpg","https://media.gemworkers.com/items/9c7d7d92-f73c-49ff-9081-e4e54d70fef2/etsy-3.jpg","https://media.gemworkers.com/items/9c7d7d92-f73c-49ff-9081-e4e54d70fef2/etsy-4.jpg","https://media.gemworkers.com/items/9c7d7d92-f73c-49ff-9081-e4e54d70fef2/etsy-5.jpg","https://media.gemworkers.com/items/9c7d7d92-f73c-49ff-9081-e4e54d70fef2/etsy-6.jpg","https://media.gemworkers.com/items/9c7d7d92-f73c-49ff-9081-e4e54d70fef2/etsy-7.jpg","https://media.gemworkers.com/items/9c7d7d92-f73c-49ff-9081-e4e54d70fef2/etsy-8.jpg","https://media.gemworkers.com/items/9c7d7d92-f73c-49ff-9081-e4e54d70fef2/etsy-9.jpg","https://media.gemworkers.com/items/9c7d7d92-f73c-49ff-9081-e4e54d70fef2/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 399 USD, converted at ECB rate. Etsy tags: Jewellery Making,Jewellery Supplies,Gemstones Jewellery,Jewellery Findings,Gift for her,Rings For Women,Rings For Men,Gold Rings,Jewels,Bluegreen tourmaline,neon tourmaline,lagoon tourmaline,mintgreentourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('c83bcf38-c7f4-4494-8f78-218ad2feee18', '4.75 Cts, Lagoon Tourmaline Pairs', 'Gorgeous Mesmerising Lagoon Afghan Tourmaline Pairs

Unique Colour And Very Bright, high lustre and brilliance 

4.75 Cts
8 x 5.1 x 4.1mm
6 x 4.9 x 3.9mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 536, 1, 'loose_stone', 'Tourmaline', NULL, 4.75, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/c83bcf38-c7f4-4494-8f78-218ad2feee18/etsy-1.jpg","https://media.gemworkers.com/items/c83bcf38-c7f4-4494-8f78-218ad2feee18/etsy-2.jpg","https://media.gemworkers.com/items/c83bcf38-c7f4-4494-8f78-218ad2feee18/etsy-3.jpg","https://media.gemworkers.com/items/c83bcf38-c7f4-4494-8f78-218ad2feee18/etsy-4.jpg","https://media.gemworkers.com/items/c83bcf38-c7f4-4494-8f78-218ad2feee18/etsy-5.jpg","https://media.gemworkers.com/items/c83bcf38-c7f4-4494-8f78-218ad2feee18/etsy-6.jpg","https://media.gemworkers.com/items/c83bcf38-c7f4-4494-8f78-218ad2feee18/etsy-7.jpg","https://media.gemworkers.com/items/c83bcf38-c7f4-4494-8f78-218ad2feee18/etsy-8.jpg","https://media.gemworkers.com/items/c83bcf38-c7f4-4494-8f78-218ad2feee18/etsy-9.jpg","https://media.gemworkers.com/items/c83bcf38-c7f4-4494-8f78-218ad2feee18/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 600 USD, converted at ECB rate. Etsy tags: BlueGreen Tourmaline,Blue Tourmaline,Green Tourmaline,Lagoon Tourmaline,Neon Tourmaline,Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery supplies,jewellery findings,gift for her,natural stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('ece6229c-9d40-42b0-a85c-061df13d670d', '4.40 Cts Tourmalines', 'pink and blue tourmaline 

High Lustre 

4.40 Cts
7 to 9mm

no treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 4.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/ece6229c-9d40-42b0-a85c-061df13d670d/etsy-1.jpg","https://media.gemworkers.com/items/ece6229c-9d40-42b0-a85c-061df13d670d/etsy-2.jpg","https://media.gemworkers.com/items/ece6229c-9d40-42b0-a85c-061df13d670d/etsy-3.jpg","https://media.gemworkers.com/items/ece6229c-9d40-42b0-a85c-061df13d670d/etsy-4.jpg","https://media.gemworkers.com/items/ece6229c-9d40-42b0-a85c-061df13d670d/etsy-5.jpg","https://media.gemworkers.com/items/ece6229c-9d40-42b0-a85c-061df13d670d/etsy-6.jpg","https://media.gemworkers.com/items/ece6229c-9d40-42b0-a85c-061df13d670d/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Jewellery Findings,Jewellery Making,Jewellery Supplies,Natural Stone,Tourmaline Jewellery,Tourmaline Jewels,Tourmaline Supplies,Gift For Her,Rings For Women,Rings For Men,Pink Tourmaline,Pure pink tourmaline,ashcher cut.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('4e7b9252-9407-43a8-9a11-9fb0b0ccaf27', '5 Cts Tourmalines', 'pink and blue tourmaline 

High Lustre 

5 Cts
8 x 7.5 x 5mm
9 x 6.5 x 4.5mm

no treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 134, 1, 'loose_stone', 'Tourmaline', NULL, 5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/4e7b9252-9407-43a8-9a11-9fb0b0ccaf27/etsy-1.jpg","https://media.gemworkers.com/items/4e7b9252-9407-43a8-9a11-9fb0b0ccaf27/etsy-2.jpg","https://media.gemworkers.com/items/4e7b9252-9407-43a8-9a11-9fb0b0ccaf27/etsy-3.jpg","https://media.gemworkers.com/items/4e7b9252-9407-43a8-9a11-9fb0b0ccaf27/etsy-4.jpg","https://media.gemworkers.com/items/4e7b9252-9407-43a8-9a11-9fb0b0ccaf27/etsy-5.jpg","https://media.gemworkers.com/items/4e7b9252-9407-43a8-9a11-9fb0b0ccaf27/etsy-6.jpg","https://media.gemworkers.com/items/4e7b9252-9407-43a8-9a11-9fb0b0ccaf27/etsy-7.jpg","https://media.gemworkers.com/items/4e7b9252-9407-43a8-9a11-9fb0b0ccaf27/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 150 USD, converted at ECB rate. Etsy tags: Jewellery Findings,Jewellery Making,Jewellery Supplies,Natural Stone,Tourmaline Jewellery,Tourmaline Jewels,Tourmaline Supplies,Gift For Her,Rings For Women,Rings For Men,Pink Tourmaline,Pure pink tourmaline,ashcher cut.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('f89443be-f8ba-4f30-b4ac-940606947076', '3 Cts Tourmalines', 'Pink Tourmaline

High Lustre 

3 Cts
7mm long



no treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 112, 1, 'loose_stone', 'Tourmaline', NULL, 3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/f89443be-f8ba-4f30-b4ac-940606947076/etsy-1.jpg","https://media.gemworkers.com/items/f89443be-f8ba-4f30-b4ac-940606947076/etsy-2.jpg","https://media.gemworkers.com/items/f89443be-f8ba-4f30-b4ac-940606947076/etsy-3.jpg","https://media.gemworkers.com/items/f89443be-f8ba-4f30-b4ac-940606947076/etsy-4.jpg","https://media.gemworkers.com/items/f89443be-f8ba-4f30-b4ac-940606947076/etsy-5.jpg","https://media.gemworkers.com/items/f89443be-f8ba-4f30-b4ac-940606947076/etsy-6.jpg","https://media.gemworkers.com/items/f89443be-f8ba-4f30-b4ac-940606947076/etsy-7.jpg","https://media.gemworkers.com/items/f89443be-f8ba-4f30-b4ac-940606947076/etsy-8.jpg","https://media.gemworkers.com/items/f89443be-f8ba-4f30-b4ac-940606947076/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 125 USD, converted at ECB rate. Etsy tags: Jewellery Findings,Jewellery Making,Jewellery Supplies,Natural Stone,Tourmaline Jewellery,Tourmaline Jewels,Tourmaline Supplies,Gift For Her,Rings For Women,Rings For Men,Pink Tourmaline,Pure pink tourmaline,ashcher cut.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('d1e1d1b2-951f-4f1a-aa24-52ed00f04193', '4.80 Cts Tourmalines', 'Top Quality Tourmaline

Best and vibrant colours 

4.80 Cts
7 to 13mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 214, 1, 'loose_stone', 'Tourmaline', NULL, 4.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/d1e1d1b2-951f-4f1a-aa24-52ed00f04193/etsy-1.jpg","https://media.gemworkers.com/items/d1e1d1b2-951f-4f1a-aa24-52ed00f04193/etsy-2.jpg","https://media.gemworkers.com/items/d1e1d1b2-951f-4f1a-aa24-52ed00f04193/etsy-3.jpg","https://media.gemworkers.com/items/d1e1d1b2-951f-4f1a-aa24-52ed00f04193/etsy-4.jpg","https://media.gemworkers.com/items/d1e1d1b2-951f-4f1a-aa24-52ed00f04193/etsy-5.jpg","https://media.gemworkers.com/items/d1e1d1b2-951f-4f1a-aa24-52ed00f04193/etsy-6.jpg","https://media.gemworkers.com/items/d1e1d1b2-951f-4f1a-aa24-52ed00f04193/etsy-7.jpg","https://media.gemworkers.com/items/d1e1d1b2-951f-4f1a-aa24-52ed00f04193/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 240 USD, converted at ECB rate. Etsy tags: Tourmaline Lot,Tourmaline Jewellery,Bluegreen Tourmaline,Lagoon Tourmaline,Blue Tourmaline,Green Tourmaline,Seafoam Tourmaline,Bicolour Tourmaline,Oceangemsminerals,Mint Tourmaline,Vivid Tourmaline Lot,Tourmaline Supplies,Jewellers.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('eff6e38e-1466-4dc3-bbaa-3d320a66d28f', '14.5 Cts Tricolour Tourmaline Lot', 'To All The Bicolour Lovers Here Is An Incredible Opportunity Buy A Truly Exceptional And One Of A Kind Bicolour And Tricolour Tourmaline Lot

Mix Bicolours And Tricolours

14.50 Cts
9.9 to 5.7mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 356, 1, 'loose_stone', 'Tourmaline', NULL, 14.5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/eff6e38e-1466-4dc3-bbaa-3d320a66d28f/etsy-1.jpg","https://media.gemworkers.com/items/eff6e38e-1466-4dc3-bbaa-3d320a66d28f/etsy-2.jpg","https://media.gemworkers.com/items/eff6e38e-1466-4dc3-bbaa-3d320a66d28f/etsy-3.jpg","https://media.gemworkers.com/items/eff6e38e-1466-4dc3-bbaa-3d320a66d28f/etsy-4.jpg","https://media.gemworkers.com/items/eff6e38e-1466-4dc3-bbaa-3d320a66d28f/etsy-5.jpg","https://media.gemworkers.com/items/eff6e38e-1466-4dc3-bbaa-3d320a66d28f/etsy-6.jpg","https://media.gemworkers.com/items/eff6e38e-1466-4dc3-bbaa-3d320a66d28f/etsy-7.jpg","https://media.gemworkers.com/items/eff6e38e-1466-4dc3-bbaa-3d320a66d28f/etsy-8.jpg","https://media.gemworkers.com/items/eff6e38e-1466-4dc3-bbaa-3d320a66d28f/etsy-9.jpg","https://media.gemworkers.com/items/eff6e38e-1466-4dc3-bbaa-3d320a66d28f/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 399 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,Handmadejewellery,gift for her,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs,Canary Tourmaline,Mix Bicolour Lot.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('99b8e55d-13e4-4246-9568-4e74401a02b5', '4 Cts Seafoam Tourmaline Trillion Cut', 'Seafoam Tourmaline Trillion Cut

high lustre and brilliance, Excellent Cut and polish.

4.00 Cts
11 x 11 x 6.1mm

eye clean 

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 714, 1, 'loose_stone', 'Tourmaline', NULL, 4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/99b8e55d-13e4-4246-9568-4e74401a02b5/etsy-1.jpg","https://media.gemworkers.com/items/99b8e55d-13e4-4246-9568-4e74401a02b5/etsy-2.jpg","https://media.gemworkers.com/items/99b8e55d-13e4-4246-9568-4e74401a02b5/etsy-3.jpg","https://media.gemworkers.com/items/99b8e55d-13e4-4246-9568-4e74401a02b5/etsy-4.jpg","https://media.gemworkers.com/items/99b8e55d-13e4-4246-9568-4e74401a02b5/etsy-5.jpg","https://media.gemworkers.com/items/99b8e55d-13e4-4246-9568-4e74401a02b5/etsy-6.jpg","https://media.gemworkers.com/items/99b8e55d-13e4-4246-9568-4e74401a02b5/etsy-7.jpg","https://media.gemworkers.com/items/99b8e55d-13e4-4246-9568-4e74401a02b5/etsy-8.jpg","https://media.gemworkers.com/items/99b8e55d-13e4-4246-9568-4e74401a02b5/etsy-9.jpg","https://media.gemworkers.com/items/99b8e55d-13e4-4246-9568-4e74401a02b5/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 799 USD, converted at ECB rate. Etsy tags: Seafoam Tourmaline,Loose Gemstones,Jewellery making,jewellery supplies,jewellery findings,gift for her,natural stone,Handmadejewellery,jewels,Tourmaline Jewellery,Tourmaline Lots,Blue Tourmaline,Neon Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('cafbc69a-8556-45e1-8de9-65bdc6b66cf4', '7.70 Cts Green Tourmalines', 'Step Cushion Cut Afghan Tourmalines

7.70 Cts
5 to 8mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 214, 1, 'loose_stone', 'Tourmaline', NULL, 7.7, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/cafbc69a-8556-45e1-8de9-65bdc6b66cf4/etsy-1.jpg","https://media.gemworkers.com/items/cafbc69a-8556-45e1-8de9-65bdc6b66cf4/etsy-2.jpg","https://media.gemworkers.com/items/cafbc69a-8556-45e1-8de9-65bdc6b66cf4/etsy-3.jpg","https://media.gemworkers.com/items/cafbc69a-8556-45e1-8de9-65bdc6b66cf4/etsy-4.jpg","https://media.gemworkers.com/items/cafbc69a-8556-45e1-8de9-65bdc6b66cf4/etsy-5.jpg","https://media.gemworkers.com/items/cafbc69a-8556-45e1-8de9-65bdc6b66cf4/etsy-6.jpg","https://media.gemworkers.com/items/cafbc69a-8556-45e1-8de9-65bdc6b66cf4/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 240 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women,Cushion Cut.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('df65d7e1-a2c5-4ef5-8d31-0814b1dd576b', '1.75 Cts Hot Pink Tourmaline Pair', 'Gorgeous Hot Pink Tourmaline Pair

1.75 Cts
6 x 5 x 3.9mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 313, 1, 'loose_stone', 'Tourmaline', NULL, 1.75, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/df65d7e1-a2c5-4ef5-8d31-0814b1dd576b/etsy-1.jpg","https://media.gemworkers.com/items/df65d7e1-a2c5-4ef5-8d31-0814b1dd576b/etsy-2.jpg","https://media.gemworkers.com/items/df65d7e1-a2c5-4ef5-8d31-0814b1dd576b/etsy-3.jpg","https://media.gemworkers.com/items/df65d7e1-a2c5-4ef5-8d31-0814b1dd576b/etsy-4.jpg","https://media.gemworkers.com/items/df65d7e1-a2c5-4ef5-8d31-0814b1dd576b/etsy-5.jpg","https://media.gemworkers.com/items/df65d7e1-a2c5-4ef5-8d31-0814b1dd576b/etsy-6.jpg","https://media.gemworkers.com/items/df65d7e1-a2c5-4ef5-8d31-0814b1dd576b/etsy-7.jpg","https://media.gemworkers.com/items/df65d7e1-a2c5-4ef5-8d31-0814b1dd576b/etsy-8.jpg","https://media.gemworkers.com/items/df65d7e1-a2c5-4ef5-8d31-0814b1dd576b/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 350 USD, converted at ECB rate. Etsy tags: Rings For Men,Rings For Women,Jewellery Stud,Tourmaline Rings,Gift For Her,Gold rings,Natural Stone,Handmade,Oceangemsminerals,Unique Tourmaline,Rare Tourmaline,Pink Tourmaline Lot,Tourmaline Pair.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('9355e528-6247-476d-b53d-6a0feef0e3fa', '1.45 Cts Hot Pink Tourmaline Pair', 'Gorgeous Hot Pink Tourmaline Pair

eye clean

1.45 Cts
5.8 x 4.7 x 3.6mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 313, 1, 'loose_stone', 'Tourmaline', NULL, 1.45, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/9355e528-6247-476d-b53d-6a0feef0e3fa/etsy-1.jpg","https://media.gemworkers.com/items/9355e528-6247-476d-b53d-6a0feef0e3fa/etsy-2.jpg","https://media.gemworkers.com/items/9355e528-6247-476d-b53d-6a0feef0e3fa/etsy-3.jpg","https://media.gemworkers.com/items/9355e528-6247-476d-b53d-6a0feef0e3fa/etsy-4.jpg","https://media.gemworkers.com/items/9355e528-6247-476d-b53d-6a0feef0e3fa/etsy-5.jpg","https://media.gemworkers.com/items/9355e528-6247-476d-b53d-6a0feef0e3fa/etsy-6.jpg","https://media.gemworkers.com/items/9355e528-6247-476d-b53d-6a0feef0e3fa/etsy-7.jpg","https://media.gemworkers.com/items/9355e528-6247-476d-b53d-6a0feef0e3fa/etsy-8.jpg","https://media.gemworkers.com/items/9355e528-6247-476d-b53d-6a0feef0e3fa/etsy-9.jpg","https://media.gemworkers.com/items/9355e528-6247-476d-b53d-6a0feef0e3fa/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 350 USD, converted at ECB rate. Etsy tags: Rings For Men,Rings For Women,Jewellery Stud,Tourmaline Rings,Gift For Her,Gold rings,Natural Stone,Handmade,Oceangemsminerals,Unique Tourmaline,Rare Tourmaline,Pink Tourmaline Lot,Tourmaline Pair.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('e64a9345-aad4-4944-8335-54e19b1eebc1', '4.65 Cts Panjsher Emerald Lot', 'Gorgeous Emerald Lot From Panjsher

Colour is more beautiful in real 

4.65 Cts
6.4 to 3.8mm

Unheated, untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Emerald', NULL, 4.65, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/e64a9345-aad4-4944-8335-54e19b1eebc1/etsy-1.jpg","https://media.gemworkers.com/items/e64a9345-aad4-4944-8335-54e19b1eebc1/etsy-2.jpg","https://media.gemworkers.com/items/e64a9345-aad4-4944-8335-54e19b1eebc1/etsy-3.jpg","https://media.gemworkers.com/items/e64a9345-aad4-4944-8335-54e19b1eebc1/etsy-4.jpg","https://media.gemworkers.com/items/e64a9345-aad4-4944-8335-54e19b1eebc1/etsy-5.jpg","https://media.gemworkers.com/items/e64a9345-aad4-4944-8335-54e19b1eebc1/etsy-6.jpg","https://media.gemworkers.com/items/e64a9345-aad4-4944-8335-54e19b1eebc1/etsy-7.jpg","https://media.gemworkers.com/items/e64a9345-aad4-4944-8335-54e19b1eebc1/etsy-8.jpg","https://media.gemworkers.com/items/e64a9345-aad4-4944-8335-54e19b1eebc1/etsy-9.jpg","https://media.gemworkers.com/items/e64a9345-aad4-4944-8335-54e19b1eebc1/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Emerald,Emerald supplies,Emerald rings,Emerald earrings,Oceangemsminerals,Gift for her,Natural stone,Jewellery making,Rings for women,Rings for men,Emerald Jewellery,Bicolour Emerald,Emerald Cabochons.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('fe68b816-16a7-40f6-9a62-29408df71428', '2.5 Cts Panjsher Emerald Lot', 'Gorgeous Emerald Lot From Panjsher

Colour is more beautiful in real 

2.50 Cts
4.5 to 3.8mm

Unheated, untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Emerald', NULL, 2.5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/fe68b816-16a7-40f6-9a62-29408df71428/etsy-1.jpg","https://media.gemworkers.com/items/fe68b816-16a7-40f6-9a62-29408df71428/etsy-2.jpg","https://media.gemworkers.com/items/fe68b816-16a7-40f6-9a62-29408df71428/etsy-3.jpg","https://media.gemworkers.com/items/fe68b816-16a7-40f6-9a62-29408df71428/etsy-4.jpg","https://media.gemworkers.com/items/fe68b816-16a7-40f6-9a62-29408df71428/etsy-5.jpg","https://media.gemworkers.com/items/fe68b816-16a7-40f6-9a62-29408df71428/etsy-6.jpg","https://media.gemworkers.com/items/fe68b816-16a7-40f6-9a62-29408df71428/etsy-7.jpg","https://media.gemworkers.com/items/fe68b816-16a7-40f6-9a62-29408df71428/etsy-8.jpg","https://media.gemworkers.com/items/fe68b816-16a7-40f6-9a62-29408df71428/etsy-9.jpg","https://media.gemworkers.com/items/fe68b816-16a7-40f6-9a62-29408df71428/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Emerald,Emerald supplies,Emerald rings,Emerald earrings,Oceangemsminerals,Gift for her,Natural stone,Jewellery making,Rings for women,Rings for men,Emerald Jewellery,Bicolour Emerald,Emerald Cabochons.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('d14af107-946a-4ea9-a321-1c4e11740e6f', '3.9 Cts Neon Blue Colour Tourmalines', 'Presenting One Of The Best Colour In Tourmalines

Exceptional Colour Very Rare To Be Find, Bright Colour Not Dull.

More Beautiful In Real. Almost eye Clean

3.90 Cts
3 to 6.5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 250, 1, 'loose_stone', 'Tourmaline', NULL, 3.9, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/d14af107-946a-4ea9-a321-1c4e11740e6f/etsy-1.jpg","https://media.gemworkers.com/items/d14af107-946a-4ea9-a321-1c4e11740e6f/etsy-2.jpg","https://media.gemworkers.com/items/d14af107-946a-4ea9-a321-1c4e11740e6f/etsy-3.jpg","https://media.gemworkers.com/items/d14af107-946a-4ea9-a321-1c4e11740e6f/etsy-4.jpg","https://media.gemworkers.com/items/d14af107-946a-4ea9-a321-1c4e11740e6f/etsy-5.jpg","https://media.gemworkers.com/items/d14af107-946a-4ea9-a321-1c4e11740e6f/etsy-6.jpg","https://media.gemworkers.com/items/d14af107-946a-4ea9-a321-1c4e11740e6f/etsy-7.jpg","https://media.gemworkers.com/items/d14af107-946a-4ea9-a321-1c4e11740e6f/etsy-8.jpg","https://media.gemworkers.com/items/d14af107-946a-4ea9-a321-1c4e11740e6f/etsy-9.jpg","https://media.gemworkers.com/items/d14af107-946a-4ea9-a321-1c4e11740e6f/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 280 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('86acfe24-e31c-49ae-8186-12d480db9af5', '2.20 Cts Neon Blue Colour Tourmalines', 'Presenting One Of The Best Colour In Tourmalines

Exceptional Colour Very Rare To Be Find, Bright Colour Not Dull.

More Beautiful In Real. Almost eye Clean

2.20 Cts
13.5 x 4 x 3mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 197, 1, 'loose_stone', 'Tourmaline', NULL, 2.2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/86acfe24-e31c-49ae-8186-12d480db9af5/etsy-1.jpg","https://media.gemworkers.com/items/86acfe24-e31c-49ae-8186-12d480db9af5/etsy-2.jpg","https://media.gemworkers.com/items/86acfe24-e31c-49ae-8186-12d480db9af5/etsy-3.jpg","https://media.gemworkers.com/items/86acfe24-e31c-49ae-8186-12d480db9af5/etsy-4.jpg","https://media.gemworkers.com/items/86acfe24-e31c-49ae-8186-12d480db9af5/etsy-5.jpg","https://media.gemworkers.com/items/86acfe24-e31c-49ae-8186-12d480db9af5/etsy-6.jpg","https://media.gemworkers.com/items/86acfe24-e31c-49ae-8186-12d480db9af5/etsy-7.jpg","https://media.gemworkers.com/items/86acfe24-e31c-49ae-8186-12d480db9af5/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 220 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('29898e87-2d77-42ea-a2b5-70218f05ede7', '5.65 Cts Panjsher Emerald Lot', 'Gorgeous Emerald Lot From Panjsher

Colour is more beautiful in real 

5.65 Cts
6.6 x 5.6 x 4.8mm
6 x 5.9 x 4.4mm
6.7 x 6 x 4.7mm
6.8 x 5 x 4.1mm

Unheated, untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 313, 1, 'loose_stone', 'Emerald', NULL, 5.65, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/29898e87-2d77-42ea-a2b5-70218f05ede7/etsy-1.jpg","https://media.gemworkers.com/items/29898e87-2d77-42ea-a2b5-70218f05ede7/etsy-2.jpg","https://media.gemworkers.com/items/29898e87-2d77-42ea-a2b5-70218f05ede7/etsy-3.jpg","https://media.gemworkers.com/items/29898e87-2d77-42ea-a2b5-70218f05ede7/etsy-4.jpg","https://media.gemworkers.com/items/29898e87-2d77-42ea-a2b5-70218f05ede7/etsy-5.jpg","https://media.gemworkers.com/items/29898e87-2d77-42ea-a2b5-70218f05ede7/etsy-6.jpg","https://media.gemworkers.com/items/29898e87-2d77-42ea-a2b5-70218f05ede7/etsy-7.jpg","https://media.gemworkers.com/items/29898e87-2d77-42ea-a2b5-70218f05ede7/etsy-8.jpg","https://media.gemworkers.com/items/29898e87-2d77-42ea-a2b5-70218f05ede7/etsy-9.jpg","https://media.gemworkers.com/items/29898e87-2d77-42ea-a2b5-70218f05ede7/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 350 USD, converted at ECB rate. Etsy tags: Emerald,Emerald supplies,Emerald rings,Emerald earrings,Oceangemsminerals,Gift for her,Natural stone,Jewellery making,Rings for women,Rings for men,Emerald Jewellery,Bicolour Emerald,Emerald Cabochons.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('419f61c3-fffa-48be-b385-14d8bd6fead8', '15.45 Cts Panjsher Emerald Lot', 'Gorgeous Emerald Lot From Panjsher

Colour is more beautiful in real 

15.45 Cts
10 to 5.6mm

Unheated, untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 383, 1, 'loose_stone', 'Emerald', NULL, 15.45, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/419f61c3-fffa-48be-b385-14d8bd6fead8/etsy-1.jpg","https://media.gemworkers.com/items/419f61c3-fffa-48be-b385-14d8bd6fead8/etsy-2.jpg","https://media.gemworkers.com/items/419f61c3-fffa-48be-b385-14d8bd6fead8/etsy-3.jpg","https://media.gemworkers.com/items/419f61c3-fffa-48be-b385-14d8bd6fead8/etsy-4.jpg","https://media.gemworkers.com/items/419f61c3-fffa-48be-b385-14d8bd6fead8/etsy-5.jpg","https://media.gemworkers.com/items/419f61c3-fffa-48be-b385-14d8bd6fead8/etsy-6.jpg","https://media.gemworkers.com/items/419f61c3-fffa-48be-b385-14d8bd6fead8/etsy-7.jpg","https://media.gemworkers.com/items/419f61c3-fffa-48be-b385-14d8bd6fead8/etsy-8.jpg","https://media.gemworkers.com/items/419f61c3-fffa-48be-b385-14d8bd6fead8/etsy-9.jpg","https://media.gemworkers.com/items/419f61c3-fffa-48be-b385-14d8bd6fead8/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 429 USD, converted at ECB rate. Etsy tags: Emerald,Emerald supplies,Emerald rings,Emerald earrings,Oceangemsminerals,Gift for her,Natural stone,Jewellery making,Rings for women,Rings for men,Emerald Jewellery,Bicolour Emerald,Emerald Cabochons.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('37d27d66-cb7f-42ad-9dc0-bf3a08355e1a', '18.3 Cts Panjsher Emerald Lot', 'Gorgeous Emerald Lot From Panjsher

Colour is more beautiful in real 

18.30 Cts
14.2 to 7.8mm

Unheated, untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 313, 1, 'loose_stone', 'Emerald', NULL, 18.3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/37d27d66-cb7f-42ad-9dc0-bf3a08355e1a/etsy-1.jpg","https://media.gemworkers.com/items/37d27d66-cb7f-42ad-9dc0-bf3a08355e1a/etsy-2.jpg","https://media.gemworkers.com/items/37d27d66-cb7f-42ad-9dc0-bf3a08355e1a/etsy-3.jpg","https://media.gemworkers.com/items/37d27d66-cb7f-42ad-9dc0-bf3a08355e1a/etsy-4.jpg","https://media.gemworkers.com/items/37d27d66-cb7f-42ad-9dc0-bf3a08355e1a/etsy-5.jpg","https://media.gemworkers.com/items/37d27d66-cb7f-42ad-9dc0-bf3a08355e1a/etsy-6.jpg","https://media.gemworkers.com/items/37d27d66-cb7f-42ad-9dc0-bf3a08355e1a/etsy-7.jpg","https://media.gemworkers.com/items/37d27d66-cb7f-42ad-9dc0-bf3a08355e1a/etsy-8.jpg","https://media.gemworkers.com/items/37d27d66-cb7f-42ad-9dc0-bf3a08355e1a/etsy-9.jpg","https://media.gemworkers.com/items/37d27d66-cb7f-42ad-9dc0-bf3a08355e1a/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 350 USD, converted at ECB rate. Etsy tags: Emerald,Emerald supplies,Emerald rings,Emerald earrings,Oceangemsminerals,Gift for her,Natural stone,Jewellery making,Rings for women,Rings for men,Emerald Jewellery,Bicolour Emerald,Emerald Cabochons.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('9da155b1-047e-4307-93df-e90ea2fdae82', '14.95 Cts Panjsher Emerald Lot', 'Gorgeous Emerald Lot From Panjsher

Colour is more beautiful in real 

14.95 Cts
9.5 to 5.2mm

Unheated, untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 402, 1, 'loose_stone', 'Emerald', NULL, 14.95, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/9da155b1-047e-4307-93df-e90ea2fdae82/etsy-1.jpg","https://media.gemworkers.com/items/9da155b1-047e-4307-93df-e90ea2fdae82/etsy-2.jpg","https://media.gemworkers.com/items/9da155b1-047e-4307-93df-e90ea2fdae82/etsy-3.jpg","https://media.gemworkers.com/items/9da155b1-047e-4307-93df-e90ea2fdae82/etsy-4.jpg","https://media.gemworkers.com/items/9da155b1-047e-4307-93df-e90ea2fdae82/etsy-5.jpg","https://media.gemworkers.com/items/9da155b1-047e-4307-93df-e90ea2fdae82/etsy-6.jpg","https://media.gemworkers.com/items/9da155b1-047e-4307-93df-e90ea2fdae82/etsy-7.jpg","https://media.gemworkers.com/items/9da155b1-047e-4307-93df-e90ea2fdae82/etsy-8.jpg","https://media.gemworkers.com/items/9da155b1-047e-4307-93df-e90ea2fdae82/etsy-9.jpg","https://media.gemworkers.com/items/9da155b1-047e-4307-93df-e90ea2fdae82/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 450 USD, converted at ECB rate. Etsy tags: Emerald,Emerald supplies,Emerald rings,Emerald earrings,Oceangemsminerals,Gift for her,Natural stone,Jewellery making,Rings for women,Rings for men,Emerald Jewellery,Bicolour Emerald,Emerald Cabochons.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('c8345caa-40e4-45c5-a545-84d9da0100cd', '8.75 Cts Panjsher Emerald Lot', 'Gorgeous Emerald Lot From Panjsher

Colour is more beautiful in real 

8.75 Cts
7.8 to 4.8mm

Unheated, untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Emerald', NULL, 8.75, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/c8345caa-40e4-45c5-a545-84d9da0100cd/etsy-1.jpg","https://media.gemworkers.com/items/c8345caa-40e4-45c5-a545-84d9da0100cd/etsy-2.jpg","https://media.gemworkers.com/items/c8345caa-40e4-45c5-a545-84d9da0100cd/etsy-3.jpg","https://media.gemworkers.com/items/c8345caa-40e4-45c5-a545-84d9da0100cd/etsy-4.jpg","https://media.gemworkers.com/items/c8345caa-40e4-45c5-a545-84d9da0100cd/etsy-5.jpg","https://media.gemworkers.com/items/c8345caa-40e4-45c5-a545-84d9da0100cd/etsy-6.jpg","https://media.gemworkers.com/items/c8345caa-40e4-45c5-a545-84d9da0100cd/etsy-7.jpg","https://media.gemworkers.com/items/c8345caa-40e4-45c5-a545-84d9da0100cd/etsy-8.jpg","https://media.gemworkers.com/items/c8345caa-40e4-45c5-a545-84d9da0100cd/etsy-9.jpg","https://media.gemworkers.com/items/c8345caa-40e4-45c5-a545-84d9da0100cd/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Emerald,Emerald supplies,Emerald rings,Emerald earrings,Oceangemsminerals,Gift for her,Natural stone,Jewellery making,Rings for women,Rings for men,Emerald Jewellery,Bicolour Emerald,Emerald Cabochons.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('b17b9d2b-59e6-451c-9c25-535239c4eafe', '2 Cts Panjsher Emerald Almost Pair', 'Gorgeous Emerald Lot From Panjsher

Colour is more beautiful in real 

almost pair

2 Cts
5.4 x 5.2 x 3.9mm

Unheated, untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Emerald', NULL, 2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/b17b9d2b-59e6-451c-9c25-535239c4eafe/etsy-1.jpg","https://media.gemworkers.com/items/b17b9d2b-59e6-451c-9c25-535239c4eafe/etsy-2.jpg","https://media.gemworkers.com/items/b17b9d2b-59e6-451c-9c25-535239c4eafe/etsy-3.jpg","https://media.gemworkers.com/items/b17b9d2b-59e6-451c-9c25-535239c4eafe/etsy-4.jpg","https://media.gemworkers.com/items/b17b9d2b-59e6-451c-9c25-535239c4eafe/etsy-5.jpg","https://media.gemworkers.com/items/b17b9d2b-59e6-451c-9c25-535239c4eafe/etsy-6.jpg","https://media.gemworkers.com/items/b17b9d2b-59e6-451c-9c25-535239c4eafe/etsy-7.jpg","https://media.gemworkers.com/items/b17b9d2b-59e6-451c-9c25-535239c4eafe/etsy-8.jpg","https://media.gemworkers.com/items/b17b9d2b-59e6-451c-9c25-535239c4eafe/etsy-9.jpg","https://media.gemworkers.com/items/b17b9d2b-59e6-451c-9c25-535239c4eafe/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Emerald,Emerald supplies,Emerald rings,Emerald earrings,Oceangemsminerals,Gift for her,Natural stone,Jewellery making,Rings for women,Rings for men,Emerald Jewellery,Bicolour Emerald,Emerald Cabochons.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('b435358e-5983-4660-8e41-fae2824d7d2e', '4.55 Cts Panjsher Emerald Lot', 'Gorgeous Emerald Lot From Panjsher

Colour is more beautiful in real 

4.55 Cts
5.7 to 3.9mm

Unheated, untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Emerald', NULL, 4.55, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/b435358e-5983-4660-8e41-fae2824d7d2e/etsy-1.jpg","https://media.gemworkers.com/items/b435358e-5983-4660-8e41-fae2824d7d2e/etsy-2.jpg","https://media.gemworkers.com/items/b435358e-5983-4660-8e41-fae2824d7d2e/etsy-3.jpg","https://media.gemworkers.com/items/b435358e-5983-4660-8e41-fae2824d7d2e/etsy-4.jpg","https://media.gemworkers.com/items/b435358e-5983-4660-8e41-fae2824d7d2e/etsy-5.jpg","https://media.gemworkers.com/items/b435358e-5983-4660-8e41-fae2824d7d2e/etsy-6.jpg","https://media.gemworkers.com/items/b435358e-5983-4660-8e41-fae2824d7d2e/etsy-7.jpg","https://media.gemworkers.com/items/b435358e-5983-4660-8e41-fae2824d7d2e/etsy-8.jpg","https://media.gemworkers.com/items/b435358e-5983-4660-8e41-fae2824d7d2e/etsy-9.jpg","https://media.gemworkers.com/items/b435358e-5983-4660-8e41-fae2824d7d2e/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Emerald,Emerald supplies,Emerald rings,Emerald earrings,Oceangemsminerals,Gift for her,Natural stone,Jewellery making,Rings for women,Rings for men,Emerald Jewellery,Bicolour Emerald,Emerald Cabochons.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('004bc702-85ef-48b9-a9d3-07c790eb9259', '3.9 Cts Panjsher Emerald', 'Gorgeous Emerald Lot From Panjsher

Colour is more beautiful in real 

3.90 Cts
10.7 x 5.8 x 3.5mm
10 x 6.1 x 3.3mm

Unheated, untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Emerald', NULL, 3.9, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/004bc702-85ef-48b9-a9d3-07c790eb9259/etsy-1.jpg","https://media.gemworkers.com/items/004bc702-85ef-48b9-a9d3-07c790eb9259/etsy-2.jpg","https://media.gemworkers.com/items/004bc702-85ef-48b9-a9d3-07c790eb9259/etsy-3.jpg","https://media.gemworkers.com/items/004bc702-85ef-48b9-a9d3-07c790eb9259/etsy-4.jpg","https://media.gemworkers.com/items/004bc702-85ef-48b9-a9d3-07c790eb9259/etsy-5.jpg","https://media.gemworkers.com/items/004bc702-85ef-48b9-a9d3-07c790eb9259/etsy-6.jpg","https://media.gemworkers.com/items/004bc702-85ef-48b9-a9d3-07c790eb9259/etsy-7.jpg","https://media.gemworkers.com/items/004bc702-85ef-48b9-a9d3-07c790eb9259/etsy-8.jpg","https://media.gemworkers.com/items/004bc702-85ef-48b9-a9d3-07c790eb9259/etsy-9.jpg","https://media.gemworkers.com/items/004bc702-85ef-48b9-a9d3-07c790eb9259/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Emerald,Emerald supplies,Emerald rings,Emerald earrings,Oceangemsminerals,Gift for her,Natural stone,Jewellery making,Rings for women,Rings for men,Emerald Jewellery,Bicolour Emerald,Emerald Cabochons.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('c36c23e1-daa2-4910-bd8c-b34435a3bcc0', '5.65 Cts Panjsher Emerald', 'Gorgeous Emerald Lot From Panjsher

Colour is more beautiful in real 

5.65 Cts
10 x 8.8 x 7mm

Unheated, untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Emerald', NULL, 5.65, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/c36c23e1-daa2-4910-bd8c-b34435a3bcc0/etsy-1.jpg","https://media.gemworkers.com/items/c36c23e1-daa2-4910-bd8c-b34435a3bcc0/etsy-2.jpg","https://media.gemworkers.com/items/c36c23e1-daa2-4910-bd8c-b34435a3bcc0/etsy-3.jpg","https://media.gemworkers.com/items/c36c23e1-daa2-4910-bd8c-b34435a3bcc0/etsy-4.jpg","https://media.gemworkers.com/items/c36c23e1-daa2-4910-bd8c-b34435a3bcc0/etsy-5.jpg","https://media.gemworkers.com/items/c36c23e1-daa2-4910-bd8c-b34435a3bcc0/etsy-6.jpg","https://media.gemworkers.com/items/c36c23e1-daa2-4910-bd8c-b34435a3bcc0/etsy-7.jpg","https://media.gemworkers.com/items/c36c23e1-daa2-4910-bd8c-b34435a3bcc0/etsy-8.jpg","https://media.gemworkers.com/items/c36c23e1-daa2-4910-bd8c-b34435a3bcc0/etsy-9.jpg","https://media.gemworkers.com/items/c36c23e1-daa2-4910-bd8c-b34435a3bcc0/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Emerald,Emerald supplies,Emerald rings,Emerald earrings,Oceangemsminerals,Gift for her,Natural stone,Jewellery making,Rings for women,Rings for men,Emerald Jewellery,Bicolour Emerald,Emerald Cabochons.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('c6036a7f-8d43-4b2a-b93f-ef0411b82e80', '2.4 Cts Panjsher Emerald Lot', 'Gorgeous Emerald Lot From Panjsher

Colour is more beautiful in real 

2.40 Cts
4.9 to 4.6mm

Unheated, untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 134, 1, 'loose_stone', 'Emerald', NULL, 2.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/c6036a7f-8d43-4b2a-b93f-ef0411b82e80/etsy-1.jpg","https://media.gemworkers.com/items/c6036a7f-8d43-4b2a-b93f-ef0411b82e80/etsy-2.jpg","https://media.gemworkers.com/items/c6036a7f-8d43-4b2a-b93f-ef0411b82e80/etsy-3.jpg","https://media.gemworkers.com/items/c6036a7f-8d43-4b2a-b93f-ef0411b82e80/etsy-4.jpg","https://media.gemworkers.com/items/c6036a7f-8d43-4b2a-b93f-ef0411b82e80/etsy-5.jpg","https://media.gemworkers.com/items/c6036a7f-8d43-4b2a-b93f-ef0411b82e80/etsy-6.jpg","https://media.gemworkers.com/items/c6036a7f-8d43-4b2a-b93f-ef0411b82e80/etsy-7.jpg","https://media.gemworkers.com/items/c6036a7f-8d43-4b2a-b93f-ef0411b82e80/etsy-8.jpg","https://media.gemworkers.com/items/c6036a7f-8d43-4b2a-b93f-ef0411b82e80/etsy-9.jpg","https://media.gemworkers.com/items/c6036a7f-8d43-4b2a-b93f-ef0411b82e80/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 150 USD, converted at ECB rate. Etsy tags: Emerald,Emerald supplies,Emerald rings,Emerald earrings,Oceangemsminerals,Gift for her,Natural stone,Jewellery making,Rings for women,Rings for men,Emerald Jewellery,Bicolour Emerald,Emerald Cabochons.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('35c8f3b6-12f4-4257-a725-8025e6766858', '8.40 Cts Rare Canary Colour Tourmaline Lot', 'Canary Green Colour Mesmerising Afghan Tourmaline Lot

Exceptional Lot

4.80 Cts
7.5 to 4.2mm

no treatment, Unheated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 8.4, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/35c8f3b6-12f4-4257-a725-8025e6766858/etsy-1.jpg","https://media.gemworkers.com/items/35c8f3b6-12f4-4257-a725-8025e6766858/etsy-2.jpg","https://media.gemworkers.com/items/35c8f3b6-12f4-4257-a725-8025e6766858/etsy-3.jpg","https://media.gemworkers.com/items/35c8f3b6-12f4-4257-a725-8025e6766858/etsy-4.jpg","https://media.gemworkers.com/items/35c8f3b6-12f4-4257-a725-8025e6766858/etsy-5.jpg","https://media.gemworkers.com/items/35c8f3b6-12f4-4257-a725-8025e6766858/etsy-6.jpg","https://media.gemworkers.com/items/35c8f3b6-12f4-4257-a725-8025e6766858/etsy-7.jpg","https://media.gemworkers.com/items/35c8f3b6-12f4-4257-a725-8025e6766858/etsy-8.jpg","https://media.gemworkers.com/items/35c8f3b6-12f4-4257-a725-8025e6766858/etsy-9.jpg","https://media.gemworkers.com/items/35c8f3b6-12f4-4257-a725-8025e6766858/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Jewellery Making,Jewellery Supplies,Jewellery Findings,Tourmaline Jewellery,Tourmaline Earrings,Blue Tourmaline,Bicolour Tourmaline,Earrings Findings,y2k earrings stud,Stud earrings,Gift For Her,Natural Stone,Tourmaline Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('9135d3d3-cda9-40ec-83ae-46fd477f6e61', 'Watermelon Tourmaline Gemstone: Rare Color, High Lustre, (3.80 Cts)', 'Sweet Perfect Watermelon Tourmaline 

Unique And Rare Colour

Very Shiny And High Lustre 

3.80 Cts
15 x 6 x 4.5mm

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 535, 1, 'loose_stone', 'Tourmaline', 'Watermelon', 3.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/9135d3d3-cda9-40ec-83ae-46fd477f6e61/etsy-1.jpg","https://media.gemworkers.com/items/9135d3d3-cda9-40ec-83ae-46fd477f6e61/etsy-2.jpg","https://media.gemworkers.com/items/9135d3d3-cda9-40ec-83ae-46fd477f6e61/etsy-3.jpg","https://media.gemworkers.com/items/9135d3d3-cda9-40ec-83ae-46fd477f6e61/etsy-4.jpg","https://media.gemworkers.com/items/9135d3d3-cda9-40ec-83ae-46fd477f6e61/etsy-5.jpg","https://media.gemworkers.com/items/9135d3d3-cda9-40ec-83ae-46fd477f6e61/etsy-6.jpg","https://media.gemworkers.com/items/9135d3d3-cda9-40ec-83ae-46fd477f6e61/etsy-7.jpg","https://media.gemworkers.com/items/9135d3d3-cda9-40ec-83ae-46fd477f6e61/etsy-8.jpg","https://media.gemworkers.com/items/9135d3d3-cda9-40ec-83ae-46fd477f6e61/etsy-9.jpg","https://media.gemworkers.com/items/9135d3d3-cda9-40ec-83ae-46fd477f6e61/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 599 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Oceangemsminerals,lagoon tourmaline,tourmaline pairs,bicolour tourmaline,Watermelon Bicolour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('517d0adc-9753-48b3-8fa2-88d93b7f2b30', 'Watermelon Tourmaline Gemstone: Rare Color, High Lustre, (3.35 Cts)', 'Sweet Perfect Watermelon Tourmaline 

Unique And Rare Colour

Very Shiny And High Lustre 

3.35 Cts
25 x 4.5 x 3.2mm

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 491, 1, 'loose_stone', 'Tourmaline', 'Watermelon', 3.35, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/517d0adc-9753-48b3-8fa2-88d93b7f2b30/etsy-1.jpg","https://media.gemworkers.com/items/517d0adc-9753-48b3-8fa2-88d93b7f2b30/etsy-2.jpg","https://media.gemworkers.com/items/517d0adc-9753-48b3-8fa2-88d93b7f2b30/etsy-3.jpg","https://media.gemworkers.com/items/517d0adc-9753-48b3-8fa2-88d93b7f2b30/etsy-4.jpg","https://media.gemworkers.com/items/517d0adc-9753-48b3-8fa2-88d93b7f2b30/etsy-5.jpg","https://media.gemworkers.com/items/517d0adc-9753-48b3-8fa2-88d93b7f2b30/etsy-6.jpg","https://media.gemworkers.com/items/517d0adc-9753-48b3-8fa2-88d93b7f2b30/etsy-7.jpg","https://media.gemworkers.com/items/517d0adc-9753-48b3-8fa2-88d93b7f2b30/etsy-8.jpg","https://media.gemworkers.com/items/517d0adc-9753-48b3-8fa2-88d93b7f2b30/etsy-9.jpg","https://media.gemworkers.com/items/517d0adc-9753-48b3-8fa2-88d93b7f2b30/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 550 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Oceangemsminerals,lagoon tourmaline,tourmaline pairs,bicolour tourmaline,Watermelon Bicolour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('7a48510e-d440-4b0e-959f-33f7c27ade63', 'Watermelon Tourmaline Gemstone: Rare Color, High Lustre, (1.20 Cts)', 'Sweet Perfect Watermelon Tourmaline 

Unique And Rare Colour

Very Shiny And High Lustre 

1.20 Cts
9 x 4.5 x 3.2mm

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', 'Watermelon', 1.2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/7a48510e-d440-4b0e-959f-33f7c27ade63/etsy-1.jpg","https://media.gemworkers.com/items/7a48510e-d440-4b0e-959f-33f7c27ade63/etsy-2.jpg","https://media.gemworkers.com/items/7a48510e-d440-4b0e-959f-33f7c27ade63/etsy-3.jpg","https://media.gemworkers.com/items/7a48510e-d440-4b0e-959f-33f7c27ade63/etsy-4.jpg","https://media.gemworkers.com/items/7a48510e-d440-4b0e-959f-33f7c27ade63/etsy-5.jpg","https://media.gemworkers.com/items/7a48510e-d440-4b0e-959f-33f7c27ade63/etsy-6.jpg","https://media.gemworkers.com/items/7a48510e-d440-4b0e-959f-33f7c27ade63/etsy-7.jpg","https://media.gemworkers.com/items/7a48510e-d440-4b0e-959f-33f7c27ade63/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Oceangemsminerals,lagoon tourmaline,tourmaline pairs,bicolour tourmaline,Watermelon Bicolour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('85bc79ed-eca3-4fcf-b168-fec9de36dc21', '1.50 Cts, Ice Blue Tourmaline.', 'Gorgeous Mesmerising Ice Blue Colour Natural Afghanistan Tourmaline Pair

More beautiful In real, One of a kind

Eye Clean

1.5 Cts
4.8 x 4 x 3.5mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 1.5, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/85bc79ed-eca3-4fcf-b168-fec9de36dc21/etsy-1.jpg","https://media.gemworkers.com/items/85bc79ed-eca3-4fcf-b168-fec9de36dc21/etsy-2.jpg","https://media.gemworkers.com/items/85bc79ed-eca3-4fcf-b168-fec9de36dc21/etsy-3.jpg","https://media.gemworkers.com/items/85bc79ed-eca3-4fcf-b168-fec9de36dc21/etsy-4.jpg","https://media.gemworkers.com/items/85bc79ed-eca3-4fcf-b168-fec9de36dc21/etsy-5.jpg","https://media.gemworkers.com/items/85bc79ed-eca3-4fcf-b168-fec9de36dc21/etsy-6.jpg","https://media.gemworkers.com/items/85bc79ed-eca3-4fcf-b168-fec9de36dc21/etsy-7.jpg","https://media.gemworkers.com/items/85bc79ed-eca3-4fcf-b168-fec9de36dc21/etsy-8.jpg","https://media.gemworkers.com/items/85bc79ed-eca3-4fcf-b168-fec9de36dc21/etsy-9.jpg","https://media.gemworkers.com/items/85bc79ed-eca3-4fcf-b168-fec9de36dc21/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Jewellery Supplies,Jewellery Making,Gold Rings,Rings For Men,Rings For Women,y2k earrings stud,Gift For Her,Tourmaline Jewellery,Natural Stone,Stud Earrings,Jewellery Stud,bicolour Tourmaline,Lagoon tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('793d499c-11db-4366-a682-c6ee4694ca03', '1.40 Cts Apple Green Tourmaline Pair', 'Mesmerising Apple 🍏 Green Colour Afghan Tourmaline Pair

Ethically Sourced, Eye Clean

high lustre and brilliance 

1.40 Cts
5.3 x 5 x 3.6mm

Unheated, No treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 161, 1, 'loose_stone', 'Tourmaline', NULL, 1.4, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/793d499c-11db-4366-a682-c6ee4694ca03/etsy-1.jpg","https://media.gemworkers.com/items/793d499c-11db-4366-a682-c6ee4694ca03/etsy-2.jpg","https://media.gemworkers.com/items/793d499c-11db-4366-a682-c6ee4694ca03/etsy-3.jpg","https://media.gemworkers.com/items/793d499c-11db-4366-a682-c6ee4694ca03/etsy-4.jpg","https://media.gemworkers.com/items/793d499c-11db-4366-a682-c6ee4694ca03/etsy-5.jpg","https://media.gemworkers.com/items/793d499c-11db-4366-a682-c6ee4694ca03/etsy-6.jpg","https://media.gemworkers.com/items/793d499c-11db-4366-a682-c6ee4694ca03/etsy-7.jpg","https://media.gemworkers.com/items/793d499c-11db-4366-a682-c6ee4694ca03/etsy-8.jpg","https://media.gemworkers.com/items/793d499c-11db-4366-a682-c6ee4694ca03/etsy-9.jpg","https://media.gemworkers.com/items/793d499c-11db-4366-a682-c6ee4694ca03/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 180 USD, converted at ECB rate. Etsy tags: Jewellery Making,Rings For Women,Jewellery Finding,Rings For Men,Jewels,Gold Rings,Jewellery Supplies,Gift For Her,Natural Stone,Blue tourmaline,lagoon Tourmaline,Oceangemsminerals,AppleGreenTourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('67f44181-e246-478b-8d1f-920a9326a081', '10.25 Cts Seafoam Green Tourmaline Lot', 'Mesmerising Seafoam Green Tourmaline Lot

10.25 Cts
5 to 11.1mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 10.25, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/67f44181-e246-478b-8d1f-920a9326a081/etsy-1.jpg","https://media.gemworkers.com/items/67f44181-e246-478b-8d1f-920a9326a081/etsy-2.jpg","https://media.gemworkers.com/items/67f44181-e246-478b-8d1f-920a9326a081/etsy-3.jpg","https://media.gemworkers.com/items/67f44181-e246-478b-8d1f-920a9326a081/etsy-4.jpg","https://media.gemworkers.com/items/67f44181-e246-478b-8d1f-920a9326a081/etsy-5.jpg","https://media.gemworkers.com/items/67f44181-e246-478b-8d1f-920a9326a081/etsy-6.jpg","https://media.gemworkers.com/items/67f44181-e246-478b-8d1f-920a9326a081/etsy-7.jpg","https://media.gemworkers.com/items/67f44181-e246-478b-8d1f-920a9326a081/etsy-8.jpg","https://media.gemworkers.com/items/67f44181-e246-478b-8d1f-920a9326a081/etsy-9.jpg","https://media.gemworkers.com/items/67f44181-e246-478b-8d1f-920a9326a081/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Seafoam Tourmaline,Emerald Cut,Tourmaline Lot,Green Tourmaline,Loose Gemstones,Jewellery Making,Jewellery Supplies,jewellery findings,natural stone,jewels,Handmadejewellery,Lagoon Tourmaline,Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('a126b96b-e025-4806-9bfa-337b5fd1bb6f', '36.9 Cts Mix Colour Natural Kunzite', 'Gorgeous Natural Kunzite 

36.9 Cts
12.5 to 8.4mm

high lustre

unique and rare colour', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 197, 1, 'loose_stone', 'Kunzite', NULL, 36.9, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/a126b96b-e025-4806-9bfa-337b5fd1bb6f/etsy-1.jpg","https://media.gemworkers.com/items/a126b96b-e025-4806-9bfa-337b5fd1bb6f/etsy-2.jpg","https://media.gemworkers.com/items/a126b96b-e025-4806-9bfa-337b5fd1bb6f/etsy-3.jpg","https://media.gemworkers.com/items/a126b96b-e025-4806-9bfa-337b5fd1bb6f/etsy-4.jpg","https://media.gemworkers.com/items/a126b96b-e025-4806-9bfa-337b5fd1bb6f/etsy-5.jpg","https://media.gemworkers.com/items/a126b96b-e025-4806-9bfa-337b5fd1bb6f/etsy-6.jpg","https://media.gemworkers.com/items/a126b96b-e025-4806-9bfa-337b5fd1bb6f/etsy-7.jpg","https://media.gemworkers.com/items/a126b96b-e025-4806-9bfa-337b5fd1bb6f/etsy-8.jpg","https://media.gemworkers.com/items/a126b96b-e025-4806-9bfa-337b5fd1bb6f/etsy-9.jpg","https://media.gemworkers.com/items/a126b96b-e025-4806-9bfa-337b5fd1bb6f/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 220 USD, converted at ECB rate. Etsy tags: Terminated Crystals,Jewellery Making,Aquamarine Specimen,Collectors,AquamarineCollection,Blue Aquamarine,Green Aquamarine,Gift For Her,Natural Stone,Kunzite Crystal,Heated Kunzite,Rough Kunzite,Kunzite Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('01e9ddcb-f255-4c5b-ae71-2c406b2a2421', '91.59g  Emerald Specimen', 'Gorgeous Emerald Specimen From Chitral 

91.59 Grams

Unheated,Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 134, 1, 'specimen', 'Emerald', NULL, NULL, NULL, NULL, NULL, NULL, '["https://media.gemworkers.com/items/01e9ddcb-f255-4c5b-ae71-2c406b2a2421/etsy-1.jpg","https://media.gemworkers.com/items/01e9ddcb-f255-4c5b-ae71-2c406b2a2421/etsy-2.jpg","https://media.gemworkers.com/items/01e9ddcb-f255-4c5b-ae71-2c406b2a2421/etsy-3.jpg","https://media.gemworkers.com/items/01e9ddcb-f255-4c5b-ae71-2c406b2a2421/etsy-4.jpg","https://media.gemworkers.com/items/01e9ddcb-f255-4c5b-ae71-2c406b2a2421/etsy-5.jpg","https://media.gemworkers.com/items/01e9ddcb-f255-4c5b-ae71-2c406b2a2421/etsy-6.jpg","https://media.gemworkers.com/items/01e9ddcb-f255-4c5b-ae71-2c406b2a2421/etsy-7.jpg","https://media.gemworkers.com/items/01e9ddcb-f255-4c5b-ae71-2c406b2a2421/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 150 USD, converted at ECB rate. Etsy tags: Emerald,Emerald supplies,Emerald rings,Emerald earrings,Oceangemsminerals,Gift for her,Natural stone,Jewellery making,Rings for women,Rings for men,Jewellers,Emerald Jewellery,Bicolour Emerald.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('d739b475-297c-4d6a-9f37-287d35a813ad', '33.27g  Emerald Specimen', 'Gorgeous Emerald Specimen From Chitral 

33.27 Grams

Unheated,Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 107, 1, 'specimen', 'Emerald', NULL, NULL, NULL, NULL, NULL, NULL, '["https://media.gemworkers.com/items/d739b475-297c-4d6a-9f37-287d35a813ad/etsy-1.jpg","https://media.gemworkers.com/items/d739b475-297c-4d6a-9f37-287d35a813ad/etsy-2.jpg","https://media.gemworkers.com/items/d739b475-297c-4d6a-9f37-287d35a813ad/etsy-3.jpg","https://media.gemworkers.com/items/d739b475-297c-4d6a-9f37-287d35a813ad/etsy-4.jpg","https://media.gemworkers.com/items/d739b475-297c-4d6a-9f37-287d35a813ad/etsy-5.jpg","https://media.gemworkers.com/items/d739b475-297c-4d6a-9f37-287d35a813ad/etsy-6.jpg","https://media.gemworkers.com/items/d739b475-297c-4d6a-9f37-287d35a813ad/etsy-7.jpg","https://media.gemworkers.com/items/d739b475-297c-4d6a-9f37-287d35a813ad/etsy-8.jpg","https://media.gemworkers.com/items/d739b475-297c-4d6a-9f37-287d35a813ad/etsy-9.jpg","https://media.gemworkers.com/items/d739b475-297c-4d6a-9f37-287d35a813ad/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 120 USD, converted at ECB rate. Etsy tags: Emerald,Emerald supplies,Emerald rings,Emerald earrings,Oceangemsminerals,Gift for her,Natural stone,Jewellery making,Rings for women,Rings for men,Jewellers,Emerald Jewellery,Bicolour Emerald.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('a723b2a4-6e9a-4681-a5e3-642a9a2b6a6f', '3.4 Cts Unique Tourmaline Set', 'A Very High Lustre Unique Colour Tourmaline Set For Earrings 

High Quality Fine Cut

Eye Clean

3.40 Cts
Pair: 5.9 x 5 x 4.4mm
6 x 4.6 x 3.8mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 304, 1, 'loose_stone', 'Tourmaline', NULL, 3.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/a723b2a4-6e9a-4681-a5e3-642a9a2b6a6f/etsy-1.jpg","https://media.gemworkers.com/items/a723b2a4-6e9a-4681-a5e3-642a9a2b6a6f/etsy-2.jpg","https://media.gemworkers.com/items/a723b2a4-6e9a-4681-a5e3-642a9a2b6a6f/etsy-3.jpg","https://media.gemworkers.com/items/a723b2a4-6e9a-4681-a5e3-642a9a2b6a6f/etsy-4.jpg","https://media.gemworkers.com/items/a723b2a4-6e9a-4681-a5e3-642a9a2b6a6f/etsy-5.jpg","https://media.gemworkers.com/items/a723b2a4-6e9a-4681-a5e3-642a9a2b6a6f/etsy-6.jpg","https://media.gemworkers.com/items/a723b2a4-6e9a-4681-a5e3-642a9a2b6a6f/etsy-7.jpg","https://media.gemworkers.com/items/a723b2a4-6e9a-4681-a5e3-642a9a2b6a6f/etsy-8.jpg","https://media.gemworkers.com/items/a723b2a4-6e9a-4681-a5e3-642a9a2b6a6f/etsy-9.jpg","https://media.gemworkers.com/items/a723b2a4-6e9a-4681-a5e3-642a9a2b6a6f/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 340 USD, converted at ECB rate. Etsy tags: Tourmaline Earrings,Earrings Set,Fine Tourmaline,Canary Tourmaline,Lagoon Tourmaline,Blue Tourmaline,Yellow Tourmaline,Stud Earrings,Tourmaline Jewellery,Jewellery Set,Oceangemsminerals,Tourmaline Pairs,Lagoon Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('46477512-b3c8-43d0-8b8c-bf8dac08ce46', '2 Cts Blue Tourmaline Earrings Set', 'A Very High Lustre Unique Colour Tourmaline Set For Earrings 

High Quality Fine Cut

Eye Clean, Very Rare To Find Such Colours In This Price

2 Cts
Pair: 4.8 x 4.1 x 2.9mm
5.3 x 4.6 x 3.9mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'jewelry', 'Tourmaline', NULL, 2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/46477512-b3c8-43d0-8b8c-bf8dac08ce46/etsy-1.jpg","https://media.gemworkers.com/items/46477512-b3c8-43d0-8b8c-bf8dac08ce46/etsy-2.jpg","https://media.gemworkers.com/items/46477512-b3c8-43d0-8b8c-bf8dac08ce46/etsy-3.jpg","https://media.gemworkers.com/items/46477512-b3c8-43d0-8b8c-bf8dac08ce46/etsy-4.jpg","https://media.gemworkers.com/items/46477512-b3c8-43d0-8b8c-bf8dac08ce46/etsy-5.jpg","https://media.gemworkers.com/items/46477512-b3c8-43d0-8b8c-bf8dac08ce46/etsy-6.jpg","https://media.gemworkers.com/items/46477512-b3c8-43d0-8b8c-bf8dac08ce46/etsy-7.jpg","https://media.gemworkers.com/items/46477512-b3c8-43d0-8b8c-bf8dac08ce46/etsy-8.jpg","https://media.gemworkers.com/items/46477512-b3c8-43d0-8b8c-bf8dac08ce46/etsy-9.jpg","https://media.gemworkers.com/items/46477512-b3c8-43d0-8b8c-bf8dac08ce46/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Tourmaline Earrings,Earrings Set,Fine Tourmaline,Canary Tourmaline,Lagoon Tourmaline,Blue Tourmaline,Yellow Tourmaline,Stud Earrings,Tourmaline Jewellery,Jewellery Set,Oceangemsminerals,Tourmaline Pairs,Lagoon Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('18c5da1e-8745-4dae-95f3-6b968c78e424', '66.1 Cts Purple And Black Bicolour Tourmaline lot', 'Unique Purple And Black Combination Bicolour Tourmaline 

Exceptional And Bright Colours 

66.10 Cts
20.2 to 13.3mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 1778, 1, 'loose_stone', 'Tourmaline', NULL, 66.1, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/18c5da1e-8745-4dae-95f3-6b968c78e424/etsy-1.jpg","https://media.gemworkers.com/items/18c5da1e-8745-4dae-95f3-6b968c78e424/etsy-2.jpg","https://media.gemworkers.com/items/18c5da1e-8745-4dae-95f3-6b968c78e424/etsy-3.jpg","https://media.gemworkers.com/items/18c5da1e-8745-4dae-95f3-6b968c78e424/etsy-4.jpg","https://media.gemworkers.com/items/18c5da1e-8745-4dae-95f3-6b968c78e424/etsy-5.jpg","https://media.gemworkers.com/items/18c5da1e-8745-4dae-95f3-6b968c78e424/etsy-6.jpg","https://media.gemworkers.com/items/18c5da1e-8745-4dae-95f3-6b968c78e424/etsy-7.jpg","https://media.gemworkers.com/items/18c5da1e-8745-4dae-95f3-6b968c78e424/etsy-8.jpg","https://media.gemworkers.com/items/18c5da1e-8745-4dae-95f3-6b968c78e424/etsy-9.jpg","https://media.gemworkers.com/items/18c5da1e-8745-4dae-95f3-6b968c78e424/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 1990 USD, converted at ECB rate. Etsy tags: Oceangemsminerals,Pink Tourmaline,Lavender Tourmaline,bicolour tourmaline,Tricolour tourmaline,Lagoon tourmaline,rare tourmaline,Unique tourmaline,Rings For Men,tourmaline jewellery,Rings for women,Jewellery making,Jewellery supplies.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('b33a3be3-dbfd-4390-b5b6-78ae3897eab3', 'Watermelon Tourmaline Gemstones: Rare Color, High Lustre, Sugar Inclusions (16.5 Cts)', 'Sweet Perfect Watermelon Tourmaline 

Unique And Rare Colour

Very Shiny And High Lustre

Sugar Inclusions Gives It More Beauty 

16.50 Cts
11.5 x 9.8 x 7.9mm
13.4 x 6.9 x 5.7mm
12 x 7.8 x 3.4mm

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 714, 1, 'loose_stone', 'Tourmaline', 'Watermelon', 16.5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/b33a3be3-dbfd-4390-b5b6-78ae3897eab3/etsy-1.jpg","https://media.gemworkers.com/items/b33a3be3-dbfd-4390-b5b6-78ae3897eab3/etsy-2.jpg","https://media.gemworkers.com/items/b33a3be3-dbfd-4390-b5b6-78ae3897eab3/etsy-3.jpg","https://media.gemworkers.com/items/b33a3be3-dbfd-4390-b5b6-78ae3897eab3/etsy-4.jpg","https://media.gemworkers.com/items/b33a3be3-dbfd-4390-b5b6-78ae3897eab3/etsy-5.jpg","https://media.gemworkers.com/items/b33a3be3-dbfd-4390-b5b6-78ae3897eab3/etsy-6.jpg","https://media.gemworkers.com/items/b33a3be3-dbfd-4390-b5b6-78ae3897eab3/etsy-7.jpg","https://media.gemworkers.com/items/b33a3be3-dbfd-4390-b5b6-78ae3897eab3/etsy-8.jpg","https://media.gemworkers.com/items/b33a3be3-dbfd-4390-b5b6-78ae3897eab3/etsy-9.jpg","https://media.gemworkers.com/items/b33a3be3-dbfd-4390-b5b6-78ae3897eab3/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 799 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Oceangemsminerals,lagoon tourmaline,tourmaline pairs,bicolour tourmaline,Watermelon Bicolour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('9543b6c6-06ba-44ea-a7f8-1cf9c49871b5', '2.8 Cts Green Tourmalines', 'Mesmerising Green Colour Tourmalines

Very Beautiful And High Lustre

2.80 Cts
10 x 4.4 x 3.2mm
5.6 x 5.8 x 4.6mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 2.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/9543b6c6-06ba-44ea-a7f8-1cf9c49871b5/etsy-1.jpg","https://media.gemworkers.com/items/9543b6c6-06ba-44ea-a7f8-1cf9c49871b5/etsy-2.jpg","https://media.gemworkers.com/items/9543b6c6-06ba-44ea-a7f8-1cf9c49871b5/etsy-3.jpg","https://media.gemworkers.com/items/9543b6c6-06ba-44ea-a7f8-1cf9c49871b5/etsy-4.jpg","https://media.gemworkers.com/items/9543b6c6-06ba-44ea-a7f8-1cf9c49871b5/etsy-5.jpg","https://media.gemworkers.com/items/9543b6c6-06ba-44ea-a7f8-1cf9c49871b5/etsy-6.jpg","https://media.gemworkers.com/items/9543b6c6-06ba-44ea-a7f8-1cf9c49871b5/etsy-7.jpg","https://media.gemworkers.com/items/9543b6c6-06ba-44ea-a7f8-1cf9c49871b5/etsy-8.jpg","https://media.gemworkers.com/items/9543b6c6-06ba-44ea-a7f8-1cf9c49871b5/etsy-9.jpg","https://media.gemworkers.com/items/9543b6c6-06ba-44ea-a7f8-1cf9c49871b5/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Jewellery Supplies,Gift For Her,Natural Stone,Silver Sterling,Gold Ring,Tourmaline Jewellery,y2k earrings stud,Seafoam Tourmaline,Mint Tourmaline,Blue Tourmaline,Jewels,lagoon tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('bfe80514-a038-4b49-a30d-34eb2d9d063d', '5.55 Cts Unique Bicolour Tourmalines', 'Rare Bicolour Tourmalines

5.55 Cts
10 x 4.8 x 3.7mm
10.4 x 4.4 x 3.7mm
10.7 x 4.8 x 3.4mm

no heat, no treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 5.55, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/bfe80514-a038-4b49-a30d-34eb2d9d063d/etsy-1.jpg","https://media.gemworkers.com/items/bfe80514-a038-4b49-a30d-34eb2d9d063d/etsy-2.jpg","https://media.gemworkers.com/items/bfe80514-a038-4b49-a30d-34eb2d9d063d/etsy-3.jpg","https://media.gemworkers.com/items/bfe80514-a038-4b49-a30d-34eb2d9d063d/etsy-4.jpg","https://media.gemworkers.com/items/bfe80514-a038-4b49-a30d-34eb2d9d063d/etsy-5.jpg","https://media.gemworkers.com/items/bfe80514-a038-4b49-a30d-34eb2d9d063d/etsy-6.jpg","https://media.gemworkers.com/items/bfe80514-a038-4b49-a30d-34eb2d9d063d/etsy-7.jpg","https://media.gemworkers.com/items/bfe80514-a038-4b49-a30d-34eb2d9d063d/etsy-8.jpg","https://media.gemworkers.com/items/bfe80514-a038-4b49-a30d-34eb2d9d063d/etsy-9.jpg","https://media.gemworkers.com/items/bfe80514-a038-4b49-a30d-34eb2d9d063d/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Bicolour Tourmaline,Blue and pink,Tourmaline set,Tourmaline pairs,Lagoon tourmaline,Neon blue tourmaline,Earrings set,Jewellery making,Jewellery supplies,Jewellery findings,Gift for her,Handmadejewellery,Natural stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('ab4e6d4e-7591-4130-b045-c87fa9956d89', '3 Cts Neon Blue And Pink Bicolour Tourmalines', 'Top Quality Neon Blue And Pink Bicolour Tourmaline Emerald Cut 

rare find

almost pair and single stone

3.0 Cts
9.2 x 3.7 x 3.3mm
7.4 x 3.8 x 3.4mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 491, 1, 'loose_stone', 'Tourmaline', NULL, 3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/ab4e6d4e-7591-4130-b045-c87fa9956d89/etsy-1.jpg","https://media.gemworkers.com/items/ab4e6d4e-7591-4130-b045-c87fa9956d89/etsy-2.jpg","https://media.gemworkers.com/items/ab4e6d4e-7591-4130-b045-c87fa9956d89/etsy-3.jpg","https://media.gemworkers.com/items/ab4e6d4e-7591-4130-b045-c87fa9956d89/etsy-4.jpg","https://media.gemworkers.com/items/ab4e6d4e-7591-4130-b045-c87fa9956d89/etsy-5.jpg","https://media.gemworkers.com/items/ab4e6d4e-7591-4130-b045-c87fa9956d89/etsy-6.jpg","https://media.gemworkers.com/items/ab4e6d4e-7591-4130-b045-c87fa9956d89/etsy-7.jpg","https://media.gemworkers.com/items/ab4e6d4e-7591-4130-b045-c87fa9956d89/etsy-8.jpg","https://media.gemworkers.com/items/ab4e6d4e-7591-4130-b045-c87fa9956d89/etsy-9.jpg","https://media.gemworkers.com/items/ab4e6d4e-7591-4130-b045-c87fa9956d89/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 550 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('de2a46ef-f45f-48f7-bff5-a03c63bebb0d', '1.5 Cts Blue and Green Tourmaline', 'Mesmerising Blue and  Green Colour Tourmalines

Very Beautiful And High Lustre

1.5 Cts
5 to 5.5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 1.5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/de2a46ef-f45f-48f7-bff5-a03c63bebb0d/etsy-1.jpg","https://media.gemworkers.com/items/de2a46ef-f45f-48f7-bff5-a03c63bebb0d/etsy-2.jpg","https://media.gemworkers.com/items/de2a46ef-f45f-48f7-bff5-a03c63bebb0d/etsy-3.jpg","https://media.gemworkers.com/items/de2a46ef-f45f-48f7-bff5-a03c63bebb0d/etsy-4.jpg","https://media.gemworkers.com/items/de2a46ef-f45f-48f7-bff5-a03c63bebb0d/etsy-5.jpg","https://media.gemworkers.com/items/de2a46ef-f45f-48f7-bff5-a03c63bebb0d/etsy-6.jpg","https://media.gemworkers.com/items/de2a46ef-f45f-48f7-bff5-a03c63bebb0d/etsy-7.jpg","https://media.gemworkers.com/items/de2a46ef-f45f-48f7-bff5-a03c63bebb0d/etsy-8.jpg","https://media.gemworkers.com/items/de2a46ef-f45f-48f7-bff5-a03c63bebb0d/etsy-9.jpg","https://media.gemworkers.com/items/de2a46ef-f45f-48f7-bff5-a03c63bebb0d/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Jewellery Supplies,Gift For Her,Natural Stone,Silver Sterling,Gold Ring,Tourmaline Jewellery,y2k earrings stud,Seafoam Tourmaline,Mint Tourmaline,Blue Tourmaline,Jewels,lagoon tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('21edea16-cf97-4d4e-8155-8294aab1cd2b', '4 Cts, Unique Bicolour Tourmalines', 'Gorgeous Mesmerising Natural Bicolour Afghan Tourmalines

high lustre, Saturated Colour.

4 Cts
6.9 to 7.6mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 4, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/21edea16-cf97-4d4e-8155-8294aab1cd2b/etsy-1.jpg","https://media.gemworkers.com/items/21edea16-cf97-4d4e-8155-8294aab1cd2b/etsy-2.jpg","https://media.gemworkers.com/items/21edea16-cf97-4d4e-8155-8294aab1cd2b/etsy-3.jpg","https://media.gemworkers.com/items/21edea16-cf97-4d4e-8155-8294aab1cd2b/etsy-4.jpg","https://media.gemworkers.com/items/21edea16-cf97-4d4e-8155-8294aab1cd2b/etsy-5.jpg","https://media.gemworkers.com/items/21edea16-cf97-4d4e-8155-8294aab1cd2b/etsy-6.jpg","https://media.gemworkers.com/items/21edea16-cf97-4d4e-8155-8294aab1cd2b/etsy-7.jpg","https://media.gemworkers.com/items/21edea16-cf97-4d4e-8155-8294aab1cd2b/etsy-8.jpg","https://media.gemworkers.com/items/21edea16-cf97-4d4e-8155-8294aab1cd2b/etsy-9.jpg","https://media.gemworkers.com/items/21edea16-cf97-4d4e-8155-8294aab1cd2b/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery findings,gift for her,natural stone,Oceangemsminerals,apple green colour,Bicolour Tourmaline,Natural Bicolour,Unheated Tourmaline,Lipstick Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('b88199bc-30d1-4c92-b8ae-604947f39c71', '4.6 Cts Blue Green Tourmalines', 'Mesmerising Blue Green Colour Tourmalines

Very Beautiful And High Lustre

4.60 Cts
9 to 10.3mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 4.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/b88199bc-30d1-4c92-b8ae-604947f39c71/etsy-1.jpg","https://media.gemworkers.com/items/b88199bc-30d1-4c92-b8ae-604947f39c71/etsy-2.jpg","https://media.gemworkers.com/items/b88199bc-30d1-4c92-b8ae-604947f39c71/etsy-3.jpg","https://media.gemworkers.com/items/b88199bc-30d1-4c92-b8ae-604947f39c71/etsy-4.jpg","https://media.gemworkers.com/items/b88199bc-30d1-4c92-b8ae-604947f39c71/etsy-5.jpg","https://media.gemworkers.com/items/b88199bc-30d1-4c92-b8ae-604947f39c71/etsy-6.jpg","https://media.gemworkers.com/items/b88199bc-30d1-4c92-b8ae-604947f39c71/etsy-7.jpg","https://media.gemworkers.com/items/b88199bc-30d1-4c92-b8ae-604947f39c71/etsy-8.jpg","https://media.gemworkers.com/items/b88199bc-30d1-4c92-b8ae-604947f39c71/etsy-9.jpg","https://media.gemworkers.com/items/b88199bc-30d1-4c92-b8ae-604947f39c71/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Jewellery Supplies,Gift For Her,Natural Stone,Silver Sterling,Gold Ring,Tourmaline Jewellery,y2k earrings stud,Seafoam Tourmaline,Mint Tourmaline,Blue Tourmaline,Jewels,lagoon tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('8d906864-f64a-4e52-8615-3cff26fac12e', '8.4 Cts Vibrant Tourmaline Gemstone Lot: Unheated, Untreated', 'Top Quality Tourmaline Lot

Best and vibrant colours 

8.40 Cts
6.1 to 4.7mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 357, 1, 'loose_stone', 'Tourmaline', NULL, 8.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/8d906864-f64a-4e52-8615-3cff26fac12e/etsy-1.jpg","https://media.gemworkers.com/items/8d906864-f64a-4e52-8615-3cff26fac12e/etsy-2.jpg","https://media.gemworkers.com/items/8d906864-f64a-4e52-8615-3cff26fac12e/etsy-3.jpg","https://media.gemworkers.com/items/8d906864-f64a-4e52-8615-3cff26fac12e/etsy-4.jpg","https://media.gemworkers.com/items/8d906864-f64a-4e52-8615-3cff26fac12e/etsy-5.jpg","https://media.gemworkers.com/items/8d906864-f64a-4e52-8615-3cff26fac12e/etsy-6.jpg","https://media.gemworkers.com/items/8d906864-f64a-4e52-8615-3cff26fac12e/etsy-7.jpg","https://media.gemworkers.com/items/8d906864-f64a-4e52-8615-3cff26fac12e/etsy-8.jpg","https://media.gemworkers.com/items/8d906864-f64a-4e52-8615-3cff26fac12e/etsy-9.jpg","https://media.gemworkers.com/items/8d906864-f64a-4e52-8615-3cff26fac12e/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 400 USD, converted at ECB rate. Etsy tags: Tourmaline Lot,Tourmaline Jewellery,Bluegreen Tourmaline,Lagoon Tourmaline,Blue Tourmaline,Green Tourmaline,Seafoam Tourmaline,Bicolour Tourmaline,Oceangemsminerals,Mint Tourmaline,Vivid Tourmaline Lot,Tourmaline Supplies,Jewellers.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('4cbb6fae-e11a-4646-a053-1aff4fd85f5c', '11.9 Cts Emerald Cut Tourmaline Lot', 'Mesmerising emerald cut Blue Green colour tourmaline Lot

11.90 Cts 
8.7 to 5.5mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 313, 1, 'loose_stone', 'Emerald', NULL, 11.9, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/4cbb6fae-e11a-4646-a053-1aff4fd85f5c/etsy-1.jpg","https://media.gemworkers.com/items/4cbb6fae-e11a-4646-a053-1aff4fd85f5c/etsy-2.jpg","https://media.gemworkers.com/items/4cbb6fae-e11a-4646-a053-1aff4fd85f5c/etsy-3.jpg","https://media.gemworkers.com/items/4cbb6fae-e11a-4646-a053-1aff4fd85f5c/etsy-4.jpg","https://media.gemworkers.com/items/4cbb6fae-e11a-4646-a053-1aff4fd85f5c/etsy-5.jpg","https://media.gemworkers.com/items/4cbb6fae-e11a-4646-a053-1aff4fd85f5c/etsy-6.jpg","https://media.gemworkers.com/items/4cbb6fae-e11a-4646-a053-1aff4fd85f5c/etsy-7.jpg","https://media.gemworkers.com/items/4cbb6fae-e11a-4646-a053-1aff4fd85f5c/etsy-8.jpg","https://media.gemworkers.com/items/4cbb6fae-e11a-4646-a053-1aff4fd85f5c/etsy-9.jpg","https://media.gemworkers.com/items/4cbb6fae-e11a-4646-a053-1aff4fd85f5c/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 350 USD, converted at ECB rate. Etsy tags: Jewellery Making,Jewellery Findings,Tourmaline Jewellery,Tourmaline Supplies,Tourmaline Lot,Mix Color Tourmaline,Natural Stone,Pink Tourmaline,Gift For Her,Necklace Findings,blue tourmaline,lagoon tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('91884a64-9909-4d6e-b448-e0516761c54e', '11.9 Cts Cushion Cut Tourmaline Lot', 'Mesmerising cushion cut mix colour tourmaline Lot

11.9 Cts 
9.9 to 7.6mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 536, 1, 'loose_stone', 'Tourmaline', NULL, 11.9, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/91884a64-9909-4d6e-b448-e0516761c54e/etsy-1.jpg","https://media.gemworkers.com/items/91884a64-9909-4d6e-b448-e0516761c54e/etsy-2.jpg","https://media.gemworkers.com/items/91884a64-9909-4d6e-b448-e0516761c54e/etsy-3.jpg","https://media.gemworkers.com/items/91884a64-9909-4d6e-b448-e0516761c54e/etsy-4.jpg","https://media.gemworkers.com/items/91884a64-9909-4d6e-b448-e0516761c54e/etsy-5.jpg","https://media.gemworkers.com/items/91884a64-9909-4d6e-b448-e0516761c54e/etsy-6.jpg","https://media.gemworkers.com/items/91884a64-9909-4d6e-b448-e0516761c54e/etsy-7.jpg","https://media.gemworkers.com/items/91884a64-9909-4d6e-b448-e0516761c54e/etsy-8.jpg","https://media.gemworkers.com/items/91884a64-9909-4d6e-b448-e0516761c54e/etsy-9.jpg","https://media.gemworkers.com/items/91884a64-9909-4d6e-b448-e0516761c54e/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 600 USD, converted at ECB rate. Etsy tags: Jewellery Making,Jewellery Findings,Tourmaline Jewellery,Tourmaline Supplies,Tourmaline Lot,Mix Color Tourmaline,Natural Stone,Pink Tourmaline,Gift For Her,Necklace Findings,blue tourmaline,lagoon tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('836966fa-5430-4389-a2f2-63432be3a1c4', '6.6 Cts Bicolour Tourmalines', 'Natural bicolour mesmerising tourmalines

6.60 Cts
8.6 to 6.1mm

unheated,', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 6.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/836966fa-5430-4389-a2f2-63432be3a1c4/etsy-1.jpg","https://media.gemworkers.com/items/836966fa-5430-4389-a2f2-63432be3a1c4/etsy-2.jpg","https://media.gemworkers.com/items/836966fa-5430-4389-a2f2-63432be3a1c4/etsy-3.jpg","https://media.gemworkers.com/items/836966fa-5430-4389-a2f2-63432be3a1c4/etsy-4.jpg","https://media.gemworkers.com/items/836966fa-5430-4389-a2f2-63432be3a1c4/etsy-5.jpg","https://media.gemworkers.com/items/836966fa-5430-4389-a2f2-63432be3a1c4/etsy-6.jpg","https://media.gemworkers.com/items/836966fa-5430-4389-a2f2-63432be3a1c4/etsy-7.jpg","https://media.gemworkers.com/items/836966fa-5430-4389-a2f2-63432be3a1c4/etsy-8.jpg","https://media.gemworkers.com/items/836966fa-5430-4389-a2f2-63432be3a1c4/etsy-9.jpg","https://media.gemworkers.com/items/836966fa-5430-4389-a2f2-63432be3a1c4/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Rings for women,rings for men,natural stone,gift for her,jewellery making,jewellery supplies,jewellery findings,bicolour tourmaline,pink tourmaline,stud jewellery,tourmaline emerald,emerald cut,green tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('e2c41db4-9e2a-423e-9f4d-38f267d2ccba', '23.90 Cts Blue Tourmaline Rosecuts Lot', 'Gorgeous High Lustre Seafoam Blue Colour Tourmaline Rosecuts Lot

High Quality Rosecuts

23.90 Cts
4 to 9mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 161, 1, 'loose_stone', 'Tourmaline', NULL, 23.9, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/e2c41db4-9e2a-423e-9f4d-38f267d2ccba/etsy-1.jpg","https://media.gemworkers.com/items/e2c41db4-9e2a-423e-9f4d-38f267d2ccba/etsy-2.jpg","https://media.gemworkers.com/items/e2c41db4-9e2a-423e-9f4d-38f267d2ccba/etsy-3.jpg","https://media.gemworkers.com/items/e2c41db4-9e2a-423e-9f4d-38f267d2ccba/etsy-4.jpg","https://media.gemworkers.com/items/e2c41db4-9e2a-423e-9f4d-38f267d2ccba/etsy-5.jpg","https://media.gemworkers.com/items/e2c41db4-9e2a-423e-9f4d-38f267d2ccba/etsy-6.jpg","https://media.gemworkers.com/items/e2c41db4-9e2a-423e-9f4d-38f267d2ccba/etsy-7.jpg","https://media.gemworkers.com/items/e2c41db4-9e2a-423e-9f4d-38f267d2ccba/etsy-8.jpg","https://media.gemworkers.com/items/e2c41db4-9e2a-423e-9f4d-38f267d2ccba/etsy-9.jpg","https://media.gemworkers.com/items/e2c41db4-9e2a-423e-9f4d-38f267d2ccba/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 180 USD, converted at ECB rate. Etsy tags: Rings For Men,Tourmaline Jewellery,Natural Stone,bicolour Tourmaline,Lagoon tourmaline,Bluegreen tourmaline,blue tourmaline,tourmaline rings,faceted tourmaline,Oceangemsminerals,Paraiba Tourmaline,Paraiba Cabochon,Blue Cabochons.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('1b7302ff-ab5f-4d89-9e2a-68318a6a8e48', '1.7 Cts Blue Green Colour Tourmaline', 'Mesmerising Blue Green Colour Afghan Tourmaline 

Ethically sourced, 

best for ring

1.70 Cts
8.3 x 5.6 x 4mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 1.7, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/1b7302ff-ab5f-4d89-9e2a-68318a6a8e48/etsy-1.jpg","https://media.gemworkers.com/items/1b7302ff-ab5f-4d89-9e2a-68318a6a8e48/etsy-2.jpg","https://media.gemworkers.com/items/1b7302ff-ab5f-4d89-9e2a-68318a6a8e48/etsy-3.jpg","https://media.gemworkers.com/items/1b7302ff-ab5f-4d89-9e2a-68318a6a8e48/etsy-4.jpg","https://media.gemworkers.com/items/1b7302ff-ab5f-4d89-9e2a-68318a6a8e48/etsy-5.jpg","https://media.gemworkers.com/items/1b7302ff-ab5f-4d89-9e2a-68318a6a8e48/etsy-6.jpg","https://media.gemworkers.com/items/1b7302ff-ab5f-4d89-9e2a-68318a6a8e48/etsy-7.jpg","https://media.gemworkers.com/items/1b7302ff-ab5f-4d89-9e2a-68318a6a8e48/etsy-8.jpg","https://media.gemworkers.com/items/1b7302ff-ab5f-4d89-9e2a-68318a6a8e48/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Bluegreen Tourmaline,Blue Tourmaline,Green Tourmaline,Jewellery supplies,jewellery making,jewellery findings,jewels,Handmadejewellery,cushion cut,gift for her,natural stone,gold rings,silver stirring.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('8a66e4e7-6f4e-4eb6-93c3-d7761ec4ea40', '1.75 Cts Blue Green Colour Tourmaline', 'Mesmerising Blue Green Colour Afghan Tourmaline 

Ethically sourced, 

best for ring

1.75 Cts
6.7 x 6.7 x 5.3mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 1.75, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/8a66e4e7-6f4e-4eb6-93c3-d7761ec4ea40/etsy-1.jpg","https://media.gemworkers.com/items/8a66e4e7-6f4e-4eb6-93c3-d7761ec4ea40/etsy-2.jpg","https://media.gemworkers.com/items/8a66e4e7-6f4e-4eb6-93c3-d7761ec4ea40/etsy-3.jpg","https://media.gemworkers.com/items/8a66e4e7-6f4e-4eb6-93c3-d7761ec4ea40/etsy-4.jpg","https://media.gemworkers.com/items/8a66e4e7-6f4e-4eb6-93c3-d7761ec4ea40/etsy-5.jpg","https://media.gemworkers.com/items/8a66e4e7-6f4e-4eb6-93c3-d7761ec4ea40/etsy-6.jpg","https://media.gemworkers.com/items/8a66e4e7-6f4e-4eb6-93c3-d7761ec4ea40/etsy-7.jpg","https://media.gemworkers.com/items/8a66e4e7-6f4e-4eb6-93c3-d7761ec4ea40/etsy-8.jpg","https://media.gemworkers.com/items/8a66e4e7-6f4e-4eb6-93c3-d7761ec4ea40/etsy-9.jpg","https://media.gemworkers.com/items/8a66e4e7-6f4e-4eb6-93c3-d7761ec4ea40/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Bluegreen Tourmaline,Blue Tourmaline,Green Tourmaline,Jewellery supplies,jewellery making,jewellery findings,jewels,Handmadejewellery,cushion cut,gift for her,natural stone,gold rings,silver stirring.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('8628f6cd-6a25-4de0-8915-8f6138df7bf3', '1.35 Cts Ink Blue Tourmaline Pair', 'Top Ink Blue Colour Tourmaline Emerald Cut 

rare find, eye clean

1.35 Cts
7 x 3.7 x 3mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 286, 1, 'loose_stone', 'Tourmaline', NULL, 1.35, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/8628f6cd-6a25-4de0-8915-8f6138df7bf3/etsy-1.jpg","https://media.gemworkers.com/items/8628f6cd-6a25-4de0-8915-8f6138df7bf3/etsy-2.jpg","https://media.gemworkers.com/items/8628f6cd-6a25-4de0-8915-8f6138df7bf3/etsy-3.jpg","https://media.gemworkers.com/items/8628f6cd-6a25-4de0-8915-8f6138df7bf3/etsy-4.jpg","https://media.gemworkers.com/items/8628f6cd-6a25-4de0-8915-8f6138df7bf3/etsy-5.jpg","https://media.gemworkers.com/items/8628f6cd-6a25-4de0-8915-8f6138df7bf3/etsy-6.jpg","https://media.gemworkers.com/items/8628f6cd-6a25-4de0-8915-8f6138df7bf3/etsy-7.jpg","https://media.gemworkers.com/items/8628f6cd-6a25-4de0-8915-8f6138df7bf3/etsy-8.jpg","https://media.gemworkers.com/items/8628f6cd-6a25-4de0-8915-8f6138df7bf3/etsy-9.jpg","https://media.gemworkers.com/items/8628f6cd-6a25-4de0-8915-8f6138df7bf3/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 320 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('ba8d6079-5982-4c9a-a303-162490cdd5cb', '1.9 Cts Lagoon Colour Tourmaline Pair', 'Presenting One Of The Best Colour In Tourmaline Pair

Exceptional Colour Very Rare To Be Find, Bright Colour Not Dull.

1.90 Cts
7.2 x 4.6 x 3.6mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 313, 1, 'loose_stone', 'Tourmaline', NULL, 1.9, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/ba8d6079-5982-4c9a-a303-162490cdd5cb/etsy-1.jpg","https://media.gemworkers.com/items/ba8d6079-5982-4c9a-a303-162490cdd5cb/etsy-2.jpg","https://media.gemworkers.com/items/ba8d6079-5982-4c9a-a303-162490cdd5cb/etsy-3.jpg","https://media.gemworkers.com/items/ba8d6079-5982-4c9a-a303-162490cdd5cb/etsy-4.jpg","https://media.gemworkers.com/items/ba8d6079-5982-4c9a-a303-162490cdd5cb/etsy-5.jpg","https://media.gemworkers.com/items/ba8d6079-5982-4c9a-a303-162490cdd5cb/etsy-6.jpg","https://media.gemworkers.com/items/ba8d6079-5982-4c9a-a303-162490cdd5cb/etsy-7.jpg","https://media.gemworkers.com/items/ba8d6079-5982-4c9a-a303-162490cdd5cb/etsy-8.jpg","https://media.gemworkers.com/items/ba8d6079-5982-4c9a-a303-162490cdd5cb/etsy-9.jpg","https://media.gemworkers.com/items/ba8d6079-5982-4c9a-a303-162490cdd5cb/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 350 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('8b65f5c7-85ed-4697-a1c7-3cc4e507af4b', '2.45 Cts Apple Green Tourmaline.', 'Gorgeous apple green Unique Tourmaline

lovely and unique piece

Excellent Cut 

2.45 Cts
7.6 x 6.7 x 5.9mm

Almost Eye Clean

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 219, 1, 'loose_stone', 'Tourmaline', NULL, 2.45, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/8b65f5c7-85ed-4697-a1c7-3cc4e507af4b/etsy-1.jpg","https://media.gemworkers.com/items/8b65f5c7-85ed-4697-a1c7-3cc4e507af4b/etsy-2.jpg","https://media.gemworkers.com/items/8b65f5c7-85ed-4697-a1c7-3cc4e507af4b/etsy-3.jpg","https://media.gemworkers.com/items/8b65f5c7-85ed-4697-a1c7-3cc4e507af4b/etsy-4.jpg","https://media.gemworkers.com/items/8b65f5c7-85ed-4697-a1c7-3cc4e507af4b/etsy-5.jpg","https://media.gemworkers.com/items/8b65f5c7-85ed-4697-a1c7-3cc4e507af4b/etsy-6.jpg","https://media.gemworkers.com/items/8b65f5c7-85ed-4697-a1c7-3cc4e507af4b/etsy-7.jpg","https://media.gemworkers.com/items/8b65f5c7-85ed-4697-a1c7-3cc4e507af4b/etsy-8.jpg","https://media.gemworkers.com/items/8b65f5c7-85ed-4697-a1c7-3cc4e507af4b/etsy-9.jpg","https://media.gemworkers.com/items/8b65f5c7-85ed-4697-a1c7-3cc4e507af4b/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 245 USD, converted at ECB rate. Etsy tags: Rings For Men,y2k earrings stud,Natural Stone,Tourmaline Supplies,Stud Earrings,pink tourmaline,Oceangemsminerals,Round Cut,Hot Pink Tourmaline,Lagoon Tourmaline,Blue Tourmaline,Bluegreen Tourmaline,Tourmaline Pair.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('cd6b4f8b-e4e8-4513-a819-00ed4eb93320', '2.85 Cts, Bicolour Tourmaline', 'Bicolour Afghan Tourmaline 

Exceptional

2.85 Cts
9.5 x 5 x 3.8mm
8.1 x 4.4 x 3.4mm

no treatment whatsoever', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 250, 1, 'loose_stone', 'Tourmaline', NULL, 2.85, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/cd6b4f8b-e4e8-4513-a819-00ed4eb93320/etsy-1.jpg","https://media.gemworkers.com/items/cd6b4f8b-e4e8-4513-a819-00ed4eb93320/etsy-2.jpg","https://media.gemworkers.com/items/cd6b4f8b-e4e8-4513-a819-00ed4eb93320/etsy-3.jpg","https://media.gemworkers.com/items/cd6b4f8b-e4e8-4513-a819-00ed4eb93320/etsy-4.jpg","https://media.gemworkers.com/items/cd6b4f8b-e4e8-4513-a819-00ed4eb93320/etsy-5.jpg","https://media.gemworkers.com/items/cd6b4f8b-e4e8-4513-a819-00ed4eb93320/etsy-6.jpg","https://media.gemworkers.com/items/cd6b4f8b-e4e8-4513-a819-00ed4eb93320/etsy-7.jpg","https://media.gemworkers.com/items/cd6b4f8b-e4e8-4513-a819-00ed4eb93320/etsy-8.jpg","https://media.gemworkers.com/items/cd6b4f8b-e4e8-4513-a819-00ed4eb93320/etsy-9.jpg","https://media.gemworkers.com/items/cd6b4f8b-e4e8-4513-a819-00ed4eb93320/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 280 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Rings,Natural Stone,Bicolour Tourmaline,Loose gemstones,Gold Rings,Rings For women,Rings For Men,y2k earrings stud,Oceangemsminerals,Lagoon Tourmaline,Blue Tourmaline,Pink Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('0f6161fa-979f-4269-9953-b76d0662d045', '9 Cts Moonstone Cabochons', 'Gorgeous Good Size Peridot Cabochons 

Origin: Pakistan 

12.50 Cts
13 x 11.5 x 9mm

Unheated Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 45, 1, 'loose_stone', 'Moonstone', NULL, 9, 'ct', 'Pakistan', NULL, NULL, '["https://media.gemworkers.com/items/0f6161fa-979f-4269-9953-b76d0662d045/etsy-1.jpg","https://media.gemworkers.com/items/0f6161fa-979f-4269-9953-b76d0662d045/etsy-2.jpg","https://media.gemworkers.com/items/0f6161fa-979f-4269-9953-b76d0662d045/etsy-3.jpg","https://media.gemworkers.com/items/0f6161fa-979f-4269-9953-b76d0662d045/etsy-4.jpg","https://media.gemworkers.com/items/0f6161fa-979f-4269-9953-b76d0662d045/etsy-5.jpg","https://media.gemworkers.com/items/0f6161fa-979f-4269-9953-b76d0662d045/etsy-6.jpg","https://media.gemworkers.com/items/0f6161fa-979f-4269-9953-b76d0662d045/etsy-7.jpg","https://media.gemworkers.com/items/0f6161fa-979f-4269-9953-b76d0662d045/etsy-8.jpg","https://media.gemworkers.com/items/0f6161fa-979f-4269-9953-b76d0662d045/etsy-9.jpg","https://media.gemworkers.com/items/0f6161fa-979f-4269-9953-b76d0662d045/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 50 USD, converted at ECB rate. Etsy tags: Natural Stone,Peridot Jewellery,Peridot Rings,Jewellery Making,Jewellery Supplies,Jewellery Findings,Gift For Her,Rings For Women,Moonstone,Moonstone Cabochon,Moonstone Sugarloaf,Sugarloaf Cabochons,Cabochons Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('6b10d8b0-2d60-4bce-b842-fc6acb66a443', '7.7 Cts, Bicolour Tourmaline Lot.', 'Pink And Neon Blue Colour Bicolour Afghan Tourmaline Lot

Exceptional

7.70 carats 

Size:4.8mm to 9.3mm

no treatment whatsoever', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 7.7, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/6b10d8b0-2d60-4bce-b842-fc6acb66a443/etsy-1.jpg","https://media.gemworkers.com/items/6b10d8b0-2d60-4bce-b842-fc6acb66a443/etsy-2.jpg","https://media.gemworkers.com/items/6b10d8b0-2d60-4bce-b842-fc6acb66a443/etsy-3.jpg","https://media.gemworkers.com/items/6b10d8b0-2d60-4bce-b842-fc6acb66a443/etsy-4.jpg","https://media.gemworkers.com/items/6b10d8b0-2d60-4bce-b842-fc6acb66a443/etsy-5.jpg","https://media.gemworkers.com/items/6b10d8b0-2d60-4bce-b842-fc6acb66a443/etsy-6.jpg","https://media.gemworkers.com/items/6b10d8b0-2d60-4bce-b842-fc6acb66a443/etsy-7.jpg","https://media.gemworkers.com/items/6b10d8b0-2d60-4bce-b842-fc6acb66a443/etsy-8.jpg","https://media.gemworkers.com/items/6b10d8b0-2d60-4bce-b842-fc6acb66a443/etsy-9.jpg","https://media.gemworkers.com/items/6b10d8b0-2d60-4bce-b842-fc6acb66a443/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Rings,Natural Stone,Bicolour Tourmaline,Loose gemstones,Gold Rings,Rings For women,Rings For Men,y2k earrings stud,Oceangemsminerals,Lagoon Tourmaline,Blue Tourmaline,Pink Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('15ebdd67-cdd5-48c9-9aaa-a0b45579a990', '2.45 Cts Loupe Clean Tourmalines', 'Gorgeous Sweet Lagoon Green And Beautiful Blue Colour Tourmalines 

Loupe Clean

2.45 Cts
5.8 x 5 x 4.1mm
6.2 x 5.3 x 4.4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 2.45, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/15ebdd67-cdd5-48c9-9aaa-a0b45579a990/etsy-1.jpg","https://media.gemworkers.com/items/15ebdd67-cdd5-48c9-9aaa-a0b45579a990/etsy-2.jpg","https://media.gemworkers.com/items/15ebdd67-cdd5-48c9-9aaa-a0b45579a990/etsy-3.jpg","https://media.gemworkers.com/items/15ebdd67-cdd5-48c9-9aaa-a0b45579a990/etsy-4.jpg","https://media.gemworkers.com/items/15ebdd67-cdd5-48c9-9aaa-a0b45579a990/etsy-5.jpg","https://media.gemworkers.com/items/15ebdd67-cdd5-48c9-9aaa-a0b45579a990/etsy-6.jpg","https://media.gemworkers.com/items/15ebdd67-cdd5-48c9-9aaa-a0b45579a990/etsy-7.jpg","https://media.gemworkers.com/items/15ebdd67-cdd5-48c9-9aaa-a0b45579a990/etsy-8.jpg","https://media.gemworkers.com/items/15ebdd67-cdd5-48c9-9aaa-a0b45579a990/etsy-9.jpg","https://media.gemworkers.com/items/15ebdd67-cdd5-48c9-9aaa-a0b45579a990/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('98c5eba1-f5eb-4b28-9dd1-f23f58520f06', '6 Cts Vibrant Tourmaline Gemstone Lot: Unheated, Untreated', 'Top Quality Tourmaline Lot

Best and vibrant colours 

6 Cts
11 to 5.1mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/98c5eba1-f5eb-4b28-9dd1-f23f58520f06/etsy-1.jpg","https://media.gemworkers.com/items/98c5eba1-f5eb-4b28-9dd1-f23f58520f06/etsy-2.jpg","https://media.gemworkers.com/items/98c5eba1-f5eb-4b28-9dd1-f23f58520f06/etsy-3.jpg","https://media.gemworkers.com/items/98c5eba1-f5eb-4b28-9dd1-f23f58520f06/etsy-4.jpg","https://media.gemworkers.com/items/98c5eba1-f5eb-4b28-9dd1-f23f58520f06/etsy-5.jpg","https://media.gemworkers.com/items/98c5eba1-f5eb-4b28-9dd1-f23f58520f06/etsy-6.jpg","https://media.gemworkers.com/items/98c5eba1-f5eb-4b28-9dd1-f23f58520f06/etsy-7.jpg","https://media.gemworkers.com/items/98c5eba1-f5eb-4b28-9dd1-f23f58520f06/etsy-8.jpg","https://media.gemworkers.com/items/98c5eba1-f5eb-4b28-9dd1-f23f58520f06/etsy-9.jpg","https://media.gemworkers.com/items/98c5eba1-f5eb-4b28-9dd1-f23f58520f06/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Tourmaline Lot,Tourmaline Jewellery,Bluegreen Tourmaline,Lagoon Tourmaline,Blue Tourmaline,Green Tourmaline,Seafoam Tourmaline,Bicolour Tourmaline,Oceangemsminerals,Mint Tourmaline,Vivid Tourmaline Lot,Tourmaline Supplies,Jewellers.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('448e3230-d28f-488e-8b48-aa76b8f3aeeb', '2.8 Cts Canary Tourmaline Pairs', 'Mesmerising Canary Colour Tourmaline Pairs For Earrings. 

One of a kind! 
not a every day color that we get 

Super special and also loupe clean

2.80 Cts
4.7 to 6.3mm

No treatment. Unheated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 500, 1, 'loose_stone', 'Tourmaline', NULL, 2.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/448e3230-d28f-488e-8b48-aa76b8f3aeeb/etsy-1.jpg","https://media.gemworkers.com/items/448e3230-d28f-488e-8b48-aa76b8f3aeeb/etsy-2.jpg","https://media.gemworkers.com/items/448e3230-d28f-488e-8b48-aa76b8f3aeeb/etsy-3.jpg","https://media.gemworkers.com/items/448e3230-d28f-488e-8b48-aa76b8f3aeeb/etsy-4.jpg","https://media.gemworkers.com/items/448e3230-d28f-488e-8b48-aa76b8f3aeeb/etsy-5.jpg","https://media.gemworkers.com/items/448e3230-d28f-488e-8b48-aa76b8f3aeeb/etsy-6.jpg","https://media.gemworkers.com/items/448e3230-d28f-488e-8b48-aa76b8f3aeeb/etsy-7.jpg","https://media.gemworkers.com/items/448e3230-d28f-488e-8b48-aa76b8f3aeeb/etsy-8.jpg","https://media.gemworkers.com/items/448e3230-d28f-488e-8b48-aa76b8f3aeeb/etsy-9.jpg","https://media.gemworkers.com/items/448e3230-d28f-488e-8b48-aa76b8f3aeeb/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 560 USD, converted at ECB rate. Etsy tags: Honey Colour,Honey Tourmaline,Tourmaline Earrings,Tourmaline set,Special tourmaline,Rare tourmaline,Cushion cut,Peardrop shape,Natural stone,Gift for her,lagoon tourmaline,blue tourmaline,tourmaline rings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('79c1da63-5365-4947-ba59-3f243818c64f', '1.6 Cts Canary Tourmaline Pair', 'Mesmerising Canary Colour Tourmaline Pair For Earrings. 

One of a kind! 
not a every day color that we get 

Super special and also loupe clean

1.60 Cts
6.5 x 5.5 x 4.2mm

No treatment. Unheated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 286, 1, 'loose_stone', 'Tourmaline', NULL, 1.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/79c1da63-5365-4947-ba59-3f243818c64f/etsy-1.jpg","https://media.gemworkers.com/items/79c1da63-5365-4947-ba59-3f243818c64f/etsy-2.jpg","https://media.gemworkers.com/items/79c1da63-5365-4947-ba59-3f243818c64f/etsy-3.jpg","https://media.gemworkers.com/items/79c1da63-5365-4947-ba59-3f243818c64f/etsy-4.jpg","https://media.gemworkers.com/items/79c1da63-5365-4947-ba59-3f243818c64f/etsy-5.jpg","https://media.gemworkers.com/items/79c1da63-5365-4947-ba59-3f243818c64f/etsy-6.jpg","https://media.gemworkers.com/items/79c1da63-5365-4947-ba59-3f243818c64f/etsy-7.jpg","https://media.gemworkers.com/items/79c1da63-5365-4947-ba59-3f243818c64f/etsy-8.jpg","https://media.gemworkers.com/items/79c1da63-5365-4947-ba59-3f243818c64f/etsy-9.jpg","https://media.gemworkers.com/items/79c1da63-5365-4947-ba59-3f243818c64f/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 320 USD, converted at ECB rate. Etsy tags: Honey Colour,Honey Tourmaline,Tourmaline Earrings,Tourmaline set,Special tourmaline,Rare tourmaline,Cushion cut,Peardrop shape,Natural stone,Gift for her,lagoon tourmaline,blue tourmaline,tourmaline rings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('affc9739-b077-43c6-b9e1-d76c9e15764e', '1.7 Cts Canary Tourmaline Pair', 'Mesmerising Canary Colour Tourmaline Pair For Earrings. 

One of a kind! 
not a every day color that we get 

Super special and also loupe clean

1.70 Cts
6.8 x 5.8 x 3.8mm

No treatment. Unheated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 286, 1, 'loose_stone', 'Tourmaline', NULL, 1.7, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/affc9739-b077-43c6-b9e1-d76c9e15764e/etsy-1.jpg","https://media.gemworkers.com/items/affc9739-b077-43c6-b9e1-d76c9e15764e/etsy-2.jpg","https://media.gemworkers.com/items/affc9739-b077-43c6-b9e1-d76c9e15764e/etsy-3.jpg","https://media.gemworkers.com/items/affc9739-b077-43c6-b9e1-d76c9e15764e/etsy-4.jpg","https://media.gemworkers.com/items/affc9739-b077-43c6-b9e1-d76c9e15764e/etsy-5.jpg","https://media.gemworkers.com/items/affc9739-b077-43c6-b9e1-d76c9e15764e/etsy-6.jpg","https://media.gemworkers.com/items/affc9739-b077-43c6-b9e1-d76c9e15764e/etsy-7.jpg","https://media.gemworkers.com/items/affc9739-b077-43c6-b9e1-d76c9e15764e/etsy-8.jpg","https://media.gemworkers.com/items/affc9739-b077-43c6-b9e1-d76c9e15764e/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 320 USD, converted at ECB rate. Etsy tags: Honey Colour,Honey Tourmaline,Tourmaline Earrings,Tourmaline set,Special tourmaline,Rare tourmaline,Cushion cut,Peardrop shape,Natural stone,Gift for her,lagoon tourmaline,blue tourmaline,tourmaline rings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('1f0aa5b1-f3aa-44a4-ac94-1d25db6f4d46', '1.5 Cts Canary Tourmaline Pair', 'Mesmerising Canary Colour Tourmaline Pair For Earrings. 

One of a kind! 
not a every day color that we get 

Super special and also loupe clean

1.50 Cts
5.6 x 5.5 x 4.2mm

No treatment. Unheated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 1.5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/1f0aa5b1-f3aa-44a4-ac94-1d25db6f4d46/etsy-1.jpg","https://media.gemworkers.com/items/1f0aa5b1-f3aa-44a4-ac94-1d25db6f4d46/etsy-2.jpg","https://media.gemworkers.com/items/1f0aa5b1-f3aa-44a4-ac94-1d25db6f4d46/etsy-3.jpg","https://media.gemworkers.com/items/1f0aa5b1-f3aa-44a4-ac94-1d25db6f4d46/etsy-4.jpg","https://media.gemworkers.com/items/1f0aa5b1-f3aa-44a4-ac94-1d25db6f4d46/etsy-5.jpg","https://media.gemworkers.com/items/1f0aa5b1-f3aa-44a4-ac94-1d25db6f4d46/etsy-6.jpg","https://media.gemworkers.com/items/1f0aa5b1-f3aa-44a4-ac94-1d25db6f4d46/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Honey Colour,Honey Tourmaline,Tourmaline Earrings,Tourmaline set,Special tourmaline,Rare tourmaline,Cushion cut,Peardrop shape,Natural stone,Gift for her,lagoon tourmaline,blue tourmaline,tourmaline rings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('f7eb829d-40db-4b41-94b2-e55d85c1e86b', '4.75 Cts Lagoon Tourmaline Set', 'Presenting One Of The Best Colour In Tourmaline Set For Ring

Exceptional Colour Very Rare To Be Find, Bright Colour Not Dull.

More Beautiful In Real.

4.75 carats 

Pair Size:5.8x4.5x3.8mm
8.6x7.1x5.3mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 339, 1, 'loose_stone', 'Tourmaline', NULL, 4.75, 'ct', NULL, NULL, '5.8x4.5x3.8', '["https://media.gemworkers.com/items/f7eb829d-40db-4b41-94b2-e55d85c1e86b/etsy-1.jpg","https://media.gemworkers.com/items/f7eb829d-40db-4b41-94b2-e55d85c1e86b/etsy-2.jpg","https://media.gemworkers.com/items/f7eb829d-40db-4b41-94b2-e55d85c1e86b/etsy-3.jpg","https://media.gemworkers.com/items/f7eb829d-40db-4b41-94b2-e55d85c1e86b/etsy-4.jpg","https://media.gemworkers.com/items/f7eb829d-40db-4b41-94b2-e55d85c1e86b/etsy-5.jpg","https://media.gemworkers.com/items/f7eb829d-40db-4b41-94b2-e55d85c1e86b/etsy-6.jpg","https://media.gemworkers.com/items/f7eb829d-40db-4b41-94b2-e55d85c1e86b/etsy-7.jpg","https://media.gemworkers.com/items/f7eb829d-40db-4b41-94b2-e55d85c1e86b/etsy-8.jpg","https://media.gemworkers.com/items/f7eb829d-40db-4b41-94b2-e55d85c1e86b/etsy-9.jpg","https://media.gemworkers.com/items/f7eb829d-40db-4b41-94b2-e55d85c1e86b/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 380 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('2bb302a8-faf4-44b7-adb6-ac5cdbbf23b3', '0.5 Cts Hot Pink Tourmaline Pair', 'Gorgeous Hot Pink Tourmaline Pair

Loupe Clean

0.50 Cts
3.6 x 3.6 x 2.8mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 0.5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/2bb302a8-faf4-44b7-adb6-ac5cdbbf23b3/etsy-1.jpg","https://media.gemworkers.com/items/2bb302a8-faf4-44b7-adb6-ac5cdbbf23b3/etsy-2.jpg","https://media.gemworkers.com/items/2bb302a8-faf4-44b7-adb6-ac5cdbbf23b3/etsy-3.jpg","https://media.gemworkers.com/items/2bb302a8-faf4-44b7-adb6-ac5cdbbf23b3/etsy-4.jpg","https://media.gemworkers.com/items/2bb302a8-faf4-44b7-adb6-ac5cdbbf23b3/etsy-5.jpg","https://media.gemworkers.com/items/2bb302a8-faf4-44b7-adb6-ac5cdbbf23b3/etsy-6.jpg","https://media.gemworkers.com/items/2bb302a8-faf4-44b7-adb6-ac5cdbbf23b3/etsy-7.jpg","https://media.gemworkers.com/items/2bb302a8-faf4-44b7-adb6-ac5cdbbf23b3/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Rings For Men,Rings For Women,Jewellery Stud,Tourmaline Rings,Gift For Her,Gold rings,Natural Stone,Handmade,Oceangemsminerals,Unique Tourmaline,Rare Tourmaline,Pink Tourmaline Lot,Tourmaline Pair.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('5048dcd1-90eb-471b-beba-74461c4daf26', '1.8 Cts Hot Pink Tourmaline', 'Gorgeous Reddish Pink Tourmaline best for ring 💍 

1.85 Cts
7.4 x 6.5 x 5.1mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 1.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/5048dcd1-90eb-471b-beba-74461c4daf26/etsy-1.jpg","https://media.gemworkers.com/items/5048dcd1-90eb-471b-beba-74461c4daf26/etsy-2.jpg","https://media.gemworkers.com/items/5048dcd1-90eb-471b-beba-74461c4daf26/etsy-3.jpg","https://media.gemworkers.com/items/5048dcd1-90eb-471b-beba-74461c4daf26/etsy-4.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('0d51434b-2e29-4407-b276-50d17a1d406d', '1.8 Cts Pink Tourmaline', 'Gorgeous Pink Tourmaline best for ring 💍 

1.80 Cts
7.8 x 6.5 x 4.8mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 1.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/0d51434b-2e29-4407-b276-50d17a1d406d/etsy-1.jpg","https://media.gemworkers.com/items/0d51434b-2e29-4407-b276-50d17a1d406d/etsy-2.jpg","https://media.gemworkers.com/items/0d51434b-2e29-4407-b276-50d17a1d406d/etsy-3.jpg","https://media.gemworkers.com/items/0d51434b-2e29-4407-b276-50d17a1d406d/etsy-4.jpg","https://media.gemworkers.com/items/0d51434b-2e29-4407-b276-50d17a1d406d/etsy-5.jpg","https://media.gemworkers.com/items/0d51434b-2e29-4407-b276-50d17a1d406d/etsy-6.jpg","https://media.gemworkers.com/items/0d51434b-2e29-4407-b276-50d17a1d406d/etsy-7.jpg","https://media.gemworkers.com/items/0d51434b-2e29-4407-b276-50d17a1d406d/etsy-8.jpg","https://media.gemworkers.com/items/0d51434b-2e29-4407-b276-50d17a1d406d/etsy-9.jpg","https://media.gemworkers.com/items/0d51434b-2e29-4407-b276-50d17a1d406d/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('c09d0cbd-48c1-47c1-bb60-e8464c2f9119', '0.8 Cts Hot Pink Round Tourmaline', 'Gorgeous Hot Pink Round Tourmaline 

Loupe Clean

Really better in real than photos

0.80 Cts
5.4 x 5.4 x 4.2mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 0.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/c09d0cbd-48c1-47c1-bb60-e8464c2f9119/etsy-1.jpg","https://media.gemworkers.com/items/c09d0cbd-48c1-47c1-bb60-e8464c2f9119/etsy-2.jpg","https://media.gemworkers.com/items/c09d0cbd-48c1-47c1-bb60-e8464c2f9119/etsy-3.jpg","https://media.gemworkers.com/items/c09d0cbd-48c1-47c1-bb60-e8464c2f9119/etsy-4.jpg","https://media.gemworkers.com/items/c09d0cbd-48c1-47c1-bb60-e8464c2f9119/etsy-5.jpg","https://media.gemworkers.com/items/c09d0cbd-48c1-47c1-bb60-e8464c2f9119/etsy-6.jpg","https://media.gemworkers.com/items/c09d0cbd-48c1-47c1-bb60-e8464c2f9119/etsy-7.jpg","https://media.gemworkers.com/items/c09d0cbd-48c1-47c1-bb60-e8464c2f9119/etsy-8.jpg","https://media.gemworkers.com/items/c09d0cbd-48c1-47c1-bb60-e8464c2f9119/etsy-9.jpg","https://media.gemworkers.com/items/c09d0cbd-48c1-47c1-bb60-e8464c2f9119/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Rings For Men,Rings For Women,Jewellery Stud,Tourmaline Rings,Gift For Her,Gold rings,Natural Stone,Handmade,Oceangemsminerals,Unique Tourmaline,Rare Tourmaline,Pink Tourmaline Lot,Tourmaline Pair.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('757d4b93-ceb3-47e4-a2d6-aa8af7264432', '5.25 Cts Pink & Ice Tourmaline Gemstones: Unheated, Untreated', 'Gorgeous Pink And Ice Colour Tourmaline

For Necklace Use And Ring Both

5.25 Cts
8 to 10mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 5.25, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/757d4b93-ceb3-47e4-a2d6-aa8af7264432/etsy-1.jpg","https://media.gemworkers.com/items/757d4b93-ceb3-47e4-a2d6-aa8af7264432/etsy-2.jpg","https://media.gemworkers.com/items/757d4b93-ceb3-47e4-a2d6-aa8af7264432/etsy-3.jpg","https://media.gemworkers.com/items/757d4b93-ceb3-47e4-a2d6-aa8af7264432/etsy-4.jpg","https://media.gemworkers.com/items/757d4b93-ceb3-47e4-a2d6-aa8af7264432/etsy-5.jpg","https://media.gemworkers.com/items/757d4b93-ceb3-47e4-a2d6-aa8af7264432/etsy-6.jpg","https://media.gemworkers.com/items/757d4b93-ceb3-47e4-a2d6-aa8af7264432/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: y2k earrings stud,Natural Stone,Tourmaline Earrings,Tourmaline Jewellery,Earrings Findings,Tourmaline Jewels,Tourmaline Supplies,Rings For Women,pink tourmaline,lagoon tourmaline,Blue tourmaline,tourmaline pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('9ab38e5e-7618-4289-bbb9-f622aefb37ee', '10.20 Cts,pink tourmaline lot', 'Elegant Afghan pink colour tourmaline 

High lustre, glowing and bright colour 

10.60 Cts
11 x 6.2 x 4mm
10 x 4.5 x 3.5mm
6.5 x 4 x 3mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 197, 1, 'loose_stone', 'Tourmaline', NULL, 10.2, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/9ab38e5e-7618-4289-bbb9-f622aefb37ee/etsy-1.jpg","https://media.gemworkers.com/items/9ab38e5e-7618-4289-bbb9-f622aefb37ee/etsy-2.jpg","https://media.gemworkers.com/items/9ab38e5e-7618-4289-bbb9-f622aefb37ee/etsy-3.jpg","https://media.gemworkers.com/items/9ab38e5e-7618-4289-bbb9-f622aefb37ee/etsy-4.jpg","https://media.gemworkers.com/items/9ab38e5e-7618-4289-bbb9-f622aefb37ee/etsy-5.jpg","https://media.gemworkers.com/items/9ab38e5e-7618-4289-bbb9-f622aefb37ee/etsy-6.jpg","https://media.gemworkers.com/items/9ab38e5e-7618-4289-bbb9-f622aefb37ee/etsy-7.jpg","https://media.gemworkers.com/items/9ab38e5e-7618-4289-bbb9-f622aefb37ee/etsy-8.jpg","https://media.gemworkers.com/items/9ab38e5e-7618-4289-bbb9-f622aefb37ee/etsy-9.jpg","https://media.gemworkers.com/items/9ab38e5e-7618-4289-bbb9-f622aefb37ee/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 220 USD, converted at ECB rate. Etsy tags: Jewellery Supplies,Jewellery Making,Rings For Men,Rings For Women,y2k earrings stud,Gift For Her,Tourmaline Jewellery,Natural Stone,Tourmaline Supplies,Stud Earrings,Jewellery Stud,pink tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('a9d5a743-8d3b-4acc-a62b-f70f9a123fce', '23.1 Cts Royal Blue Tourmaline Lot', 'Gorgeous Strong Blue Colour Afghan Tourmaline Lot

23.10 Cts
6.8 x 6.1 x 4.7mm 
10.9 x 7.8 x 6.3mm 

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 804, 1, 'loose_stone', 'Tourmaline', NULL, 23.1, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/a9d5a743-8d3b-4acc-a62b-f70f9a123fce/etsy-1.jpg","https://media.gemworkers.com/items/a9d5a743-8d3b-4acc-a62b-f70f9a123fce/etsy-2.jpg","https://media.gemworkers.com/items/a9d5a743-8d3b-4acc-a62b-f70f9a123fce/etsy-3.jpg","https://media.gemworkers.com/items/a9d5a743-8d3b-4acc-a62b-f70f9a123fce/etsy-4.jpg","https://media.gemworkers.com/items/a9d5a743-8d3b-4acc-a62b-f70f9a123fce/etsy-5.jpg","https://media.gemworkers.com/items/a9d5a743-8d3b-4acc-a62b-f70f9a123fce/etsy-6.jpg","https://media.gemworkers.com/items/a9d5a743-8d3b-4acc-a62b-f70f9a123fce/etsy-7.jpg","https://media.gemworkers.com/items/a9d5a743-8d3b-4acc-a62b-f70f9a123fce/etsy-8.jpg","https://media.gemworkers.com/items/a9d5a743-8d3b-4acc-a62b-f70f9a123fce/etsy-9.jpg","https://media.gemworkers.com/items/a9d5a743-8d3b-4acc-a62b-f70f9a123fce/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 900 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('b6b69dfe-0228-4993-a420-4b5dbea0487e', '2.40 Cts Indoclite Tourmaline.', 'Gorgeous Strong Blue Colour Afghan Tourmaline 

2.40 Cts
7.9 x 7.7 x 5.5mm

No treatment whatsoever', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 214, 1, 'loose_stone', 'Tourmaline', NULL, 2.4, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/b6b69dfe-0228-4993-a420-4b5dbea0487e/etsy-1.jpg","https://media.gemworkers.com/items/b6b69dfe-0228-4993-a420-4b5dbea0487e/etsy-2.jpg","https://media.gemworkers.com/items/b6b69dfe-0228-4993-a420-4b5dbea0487e/etsy-3.jpg","https://media.gemworkers.com/items/b6b69dfe-0228-4993-a420-4b5dbea0487e/etsy-4.jpg","https://media.gemworkers.com/items/b6b69dfe-0228-4993-a420-4b5dbea0487e/etsy-5.jpg","https://media.gemworkers.com/items/b6b69dfe-0228-4993-a420-4b5dbea0487e/etsy-6.jpg","https://media.gemworkers.com/items/b6b69dfe-0228-4993-a420-4b5dbea0487e/etsy-7.jpg","https://media.gemworkers.com/items/b6b69dfe-0228-4993-a420-4b5dbea0487e/etsy-8.jpg","https://media.gemworkers.com/items/b6b69dfe-0228-4993-a420-4b5dbea0487e/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 240 USD, converted at ECB rate. Etsy tags: Jewellery Making,Jewellery Findings,Tourmaline Rings,Tourmaline Jewellery,Rings Findings,Gold Rings,Natural Stone,Blue Tourmaline,Sapphire Blue,Gift For Her,Handmade,Lagoon Tourmaline,Ink Blue Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('490eb483-d42b-4955-986a-381252419ebd', '1.6 Cts Ink Blue Tourmaline', 'Top Colour Ink Blue Colour Tourmaline Emerald Cut 

rare find

1.60 carats 

Size:5.3mm to 5.6mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 214, 1, 'loose_stone', 'Tourmaline', NULL, 1.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/490eb483-d42b-4955-986a-381252419ebd/etsy-1.jpg","https://media.gemworkers.com/items/490eb483-d42b-4955-986a-381252419ebd/etsy-2.jpg","https://media.gemworkers.com/items/490eb483-d42b-4955-986a-381252419ebd/etsy-3.jpg","https://media.gemworkers.com/items/490eb483-d42b-4955-986a-381252419ebd/etsy-4.jpg","https://media.gemworkers.com/items/490eb483-d42b-4955-986a-381252419ebd/etsy-5.jpg","https://media.gemworkers.com/items/490eb483-d42b-4955-986a-381252419ebd/etsy-6.jpg","https://media.gemworkers.com/items/490eb483-d42b-4955-986a-381252419ebd/etsy-7.jpg","https://media.gemworkers.com/items/490eb483-d42b-4955-986a-381252419ebd/etsy-8.jpg","https://media.gemworkers.com/items/490eb483-d42b-4955-986a-381252419ebd/etsy-9.jpg","https://media.gemworkers.com/items/490eb483-d42b-4955-986a-381252419ebd/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 240 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('f9404b73-db0c-4413-987c-92a0b2555e62', '2.8 Cts indicolite Tourmaline', 'indicolite Tourmaline Emerald Cut 

rare find

2.80 carats 

Size:5.4mm to 11mm long

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 197, 1, 'loose_stone', 'Tourmaline', 'Indicolite', 2.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/f9404b73-db0c-4413-987c-92a0b2555e62/etsy-1.jpg","https://media.gemworkers.com/items/f9404b73-db0c-4413-987c-92a0b2555e62/etsy-2.jpg","https://media.gemworkers.com/items/f9404b73-db0c-4413-987c-92a0b2555e62/etsy-3.jpg","https://media.gemworkers.com/items/f9404b73-db0c-4413-987c-92a0b2555e62/etsy-4.jpg","https://media.gemworkers.com/items/f9404b73-db0c-4413-987c-92a0b2555e62/etsy-5.jpg","https://media.gemworkers.com/items/f9404b73-db0c-4413-987c-92a0b2555e62/etsy-6.jpg","https://media.gemworkers.com/items/f9404b73-db0c-4413-987c-92a0b2555e62/etsy-7.jpg","https://media.gemworkers.com/items/f9404b73-db0c-4413-987c-92a0b2555e62/etsy-8.jpg","https://media.gemworkers.com/items/f9404b73-db0c-4413-987c-92a0b2555e62/etsy-9.jpg","https://media.gemworkers.com/items/f9404b73-db0c-4413-987c-92a0b2555e62/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 220 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('3ee43684-9309-417e-b621-39101018e71f', '7.80 Cts, Unique Pink Colour Afghan Tourmaline Lot.', 'Mesmerising Unique And Rare Colour Tourmaline Lot.

Cute Looking, , high lustre

Weight:7.80 carats 
Dimension:5x5x4mm to 8x4x3mm', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 286, 1, 'loose_stone', 'Tourmaline', NULL, 7.8, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/3ee43684-9309-417e-b621-39101018e71f/etsy-1.jpg","https://media.gemworkers.com/items/3ee43684-9309-417e-b621-39101018e71f/etsy-2.jpg","https://media.gemworkers.com/items/3ee43684-9309-417e-b621-39101018e71f/etsy-3.jpg","https://media.gemworkers.com/items/3ee43684-9309-417e-b621-39101018e71f/etsy-4.jpg","https://media.gemworkers.com/items/3ee43684-9309-417e-b621-39101018e71f/etsy-5.jpg","https://media.gemworkers.com/items/3ee43684-9309-417e-b621-39101018e71f/etsy-6.jpg","https://media.gemworkers.com/items/3ee43684-9309-417e-b621-39101018e71f/etsy-7.jpg","https://media.gemworkers.com/items/3ee43684-9309-417e-b621-39101018e71f/etsy-8.jpg","https://media.gemworkers.com/items/3ee43684-9309-417e-b621-39101018e71f/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 320 USD, converted at ECB rate. Etsy tags: Rings For Men,Rings For Women,Jewellery Stud,Tourmaline Rings,Gift For Her,Gold rings,Natural Stone,Jewels,Handmade,Oceangemsminerals,Unique Tourmaline,Rare Tourmaline,Pink Tourmaline Lot.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('4d82b9db-0e49-45b8-af75-cc85819a6613', '15.25 Cts Orange Tourmaline', 'Gorgeous Orange Tourmaline 

Big Size 

Rare And One Of A Kind

sugar inclusions which give it more beauty

15.25 Cts
15.4 x 14.7 x 9.6mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 535, 1, 'loose_stone', 'Tourmaline', NULL, 15.25, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/4d82b9db-0e49-45b8-af75-cc85819a6613/etsy-1.jpg","https://media.gemworkers.com/items/4d82b9db-0e49-45b8-af75-cc85819a6613/etsy-2.jpg","https://media.gemworkers.com/items/4d82b9db-0e49-45b8-af75-cc85819a6613/etsy-3.jpg","https://media.gemworkers.com/items/4d82b9db-0e49-45b8-af75-cc85819a6613/etsy-4.jpg","https://media.gemworkers.com/items/4d82b9db-0e49-45b8-af75-cc85819a6613/etsy-5.jpg","https://media.gemworkers.com/items/4d82b9db-0e49-45b8-af75-cc85819a6613/etsy-6.jpg","https://media.gemworkers.com/items/4d82b9db-0e49-45b8-af75-cc85819a6613/etsy-7.jpg","https://media.gemworkers.com/items/4d82b9db-0e49-45b8-af75-cc85819a6613/etsy-8.jpg","https://media.gemworkers.com/items/4d82b9db-0e49-45b8-af75-cc85819a6613/etsy-9.jpg","https://media.gemworkers.com/items/4d82b9db-0e49-45b8-af75-cc85819a6613/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 599 USD, converted at ECB rate. Etsy tags: Red Tourmaline,Hot Pink Tourmaline,Pink Tourmaline,Orange Tourmaline,Unique Tourmaline,Tourmaline Jewellery,Faceted Tourmaline,Step Cushion Cut,Feceted Tourmaline,Afghan Tourmaline,Oceangemsminerals,Purple Tourmaline,Lavender Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('16aed826-a9c9-4b43-958a-790d2a05ea8f', '15.25 Cts Orange Tourmaline', 'Gorgeous Orange Tourmaline 

Big Size 

Rare And One Of A Kind

sugar inclusions which give it more beauty

15.25 Cts
15.6 x 13.5 x 10.4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 535, 1, 'loose_stone', 'Tourmaline', NULL, 15.25, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/16aed826-a9c9-4b43-958a-790d2a05ea8f/etsy-1.jpg","https://media.gemworkers.com/items/16aed826-a9c9-4b43-958a-790d2a05ea8f/etsy-2.jpg","https://media.gemworkers.com/items/16aed826-a9c9-4b43-958a-790d2a05ea8f/etsy-3.jpg","https://media.gemworkers.com/items/16aed826-a9c9-4b43-958a-790d2a05ea8f/etsy-4.jpg","https://media.gemworkers.com/items/16aed826-a9c9-4b43-958a-790d2a05ea8f/etsy-5.jpg","https://media.gemworkers.com/items/16aed826-a9c9-4b43-958a-790d2a05ea8f/etsy-6.jpg","https://media.gemworkers.com/items/16aed826-a9c9-4b43-958a-790d2a05ea8f/etsy-7.jpg","https://media.gemworkers.com/items/16aed826-a9c9-4b43-958a-790d2a05ea8f/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 599 USD, converted at ECB rate. Etsy tags: Red Tourmaline,Hot Pink Tourmaline,Pink Tourmaline,Orange Tourmaline,Unique Tourmaline,Tourmaline Jewellery,Faceted Tourmaline,Step Cushion Cut,Feceted Tourmaline,Afghan Tourmaline,Oceangemsminerals,Purple Tourmaline,Lavender Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('131ac0e7-c980-4d63-aa6e-45b1af240cf6', '7 Cts Blue And Seafoam Tourmaline Lot', 'Blue and Seafoam Colour Tourmaline Lot

One of a kind, top colours and and clarity.

7 Cts
19.90 to 8.3mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 7, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/131ac0e7-c980-4d63-aa6e-45b1af240cf6/etsy-1.jpg","https://media.gemworkers.com/items/131ac0e7-c980-4d63-aa6e-45b1af240cf6/etsy-2.jpg","https://media.gemworkers.com/items/131ac0e7-c980-4d63-aa6e-45b1af240cf6/etsy-3.jpg","https://media.gemworkers.com/items/131ac0e7-c980-4d63-aa6e-45b1af240cf6/etsy-4.jpg","https://media.gemworkers.com/items/131ac0e7-c980-4d63-aa6e-45b1af240cf6/etsy-5.jpg","https://media.gemworkers.com/items/131ac0e7-c980-4d63-aa6e-45b1af240cf6/etsy-6.jpg","https://media.gemworkers.com/items/131ac0e7-c980-4d63-aa6e-45b1af240cf6/etsy-7.jpg","https://media.gemworkers.com/items/131ac0e7-c980-4d63-aa6e-45b1af240cf6/etsy-8.jpg","https://media.gemworkers.com/items/131ac0e7-c980-4d63-aa6e-45b1af240cf6/etsy-9.jpg","https://media.gemworkers.com/items/131ac0e7-c980-4d63-aa6e-45b1af240cf6/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('21b4a1da-b22c-47a6-b152-b6f0ee749c0d', '8.4 Cts Blue Tourmaline Lot', 'Blue and Teal Blue Colour Tourmaline Lot

One of a kind, top colours and and clarity.

8.40 Cts
8.4 to 4.4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 8.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/21b4a1da-b22c-47a6-b152-b6f0ee749c0d/etsy-1.jpg","https://media.gemworkers.com/items/21b4a1da-b22c-47a6-b152-b6f0ee749c0d/etsy-2.jpg","https://media.gemworkers.com/items/21b4a1da-b22c-47a6-b152-b6f0ee749c0d/etsy-3.jpg","https://media.gemworkers.com/items/21b4a1da-b22c-47a6-b152-b6f0ee749c0d/etsy-4.jpg","https://media.gemworkers.com/items/21b4a1da-b22c-47a6-b152-b6f0ee749c0d/etsy-5.jpg","https://media.gemworkers.com/items/21b4a1da-b22c-47a6-b152-b6f0ee749c0d/etsy-6.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('44f40fda-20f0-44ff-8b42-3ee49838e603', '8.1 Cts Green Catseye Tourmaline', 'Gorgeous Mesmerising Green Cool Colour With Cat’s eye Afghan Tourmaline 

better looking in real

8.10 Cts
14.6 x 10.8 x 7.2mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 8.1, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/44f40fda-20f0-44ff-8b42-3ee49838e603/etsy-1.jpg","https://media.gemworkers.com/items/44f40fda-20f0-44ff-8b42-3ee49838e603/etsy-2.jpg","https://media.gemworkers.com/items/44f40fda-20f0-44ff-8b42-3ee49838e603/etsy-3.jpg","https://media.gemworkers.com/items/44f40fda-20f0-44ff-8b42-3ee49838e603/etsy-4.jpg","https://media.gemworkers.com/items/44f40fda-20f0-44ff-8b42-3ee49838e603/etsy-5.jpg","https://media.gemworkers.com/items/44f40fda-20f0-44ff-8b42-3ee49838e603/etsy-6.jpg","https://media.gemworkers.com/items/44f40fda-20f0-44ff-8b42-3ee49838e603/etsy-7.jpg","https://media.gemworkers.com/items/44f40fda-20f0-44ff-8b42-3ee49838e603/etsy-8.jpg","https://media.gemworkers.com/items/44f40fda-20f0-44ff-8b42-3ee49838e603/etsy-9.jpg","https://media.gemworkers.com/items/44f40fda-20f0-44ff-8b42-3ee49838e603/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Jewellery Supplies,Jewellery Making,Jewellery Findings,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Rings For Women,Chrome Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('56d3b4b0-3667-4a44-a303-251ec1ae911c', '1.70 Cts, Mint Green Tourmaline', 'Mesmerising Mint Green Colour Afghan Tourmaline 

Ethically Sourced, Loupe Clean

Cut To Perfection 

high lustre and brilliance 

1.70 Cts
7 x 6 x 5mm

Unheated, No treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 165, 1, 'loose_stone', 'Tourmaline', NULL, 1.7, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/56d3b4b0-3667-4a44-a303-251ec1ae911c/etsy-1.jpg","https://media.gemworkers.com/items/56d3b4b0-3667-4a44-a303-251ec1ae911c/etsy-2.jpg","https://media.gemworkers.com/items/56d3b4b0-3667-4a44-a303-251ec1ae911c/etsy-3.jpg","https://media.gemworkers.com/items/56d3b4b0-3667-4a44-a303-251ec1ae911c/etsy-4.jpg","https://media.gemworkers.com/items/56d3b4b0-3667-4a44-a303-251ec1ae911c/etsy-5.jpg","https://media.gemworkers.com/items/56d3b4b0-3667-4a44-a303-251ec1ae911c/etsy-6.jpg","https://media.gemworkers.com/items/56d3b4b0-3667-4a44-a303-251ec1ae911c/etsy-7.jpg","https://media.gemworkers.com/items/56d3b4b0-3667-4a44-a303-251ec1ae911c/etsy-8.jpg","https://media.gemworkers.com/items/56d3b4b0-3667-4a44-a303-251ec1ae911c/etsy-9.jpg","https://media.gemworkers.com/items/56d3b4b0-3667-4a44-a303-251ec1ae911c/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 185 USD, converted at ECB rate. Etsy tags: Jewellery Making,Rings For Women,Jewellery Finding,Rings For Men,Jewels,Gold Rings,Jewellery Supplies,Gift For Her,Natural Stone,Blue tourmaline,lagoon Tourmaline,MintGreen Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('9260356e-8f7e-4a62-be2b-67e5abf5a9cd', '1.70 Cts, Apple Green Tourmaline', 'Mesmerising Mint Green Colour Afghan Tourmaline 

Ethically Sourced, Almost Eye Clean

Cut To Perfection 

high lustre and brilliance 

1.70 Cts
7 x 6 x 4.5mm

Unheated, No treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 161, 1, 'loose_stone', 'Tourmaline', NULL, 1.7, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/9260356e-8f7e-4a62-be2b-67e5abf5a9cd/etsy-1.jpg","https://media.gemworkers.com/items/9260356e-8f7e-4a62-be2b-67e5abf5a9cd/etsy-2.jpg","https://media.gemworkers.com/items/9260356e-8f7e-4a62-be2b-67e5abf5a9cd/etsy-3.jpg","https://media.gemworkers.com/items/9260356e-8f7e-4a62-be2b-67e5abf5a9cd/etsy-4.jpg","https://media.gemworkers.com/items/9260356e-8f7e-4a62-be2b-67e5abf5a9cd/etsy-5.jpg","https://media.gemworkers.com/items/9260356e-8f7e-4a62-be2b-67e5abf5a9cd/etsy-6.jpg","https://media.gemworkers.com/items/9260356e-8f7e-4a62-be2b-67e5abf5a9cd/etsy-7.jpg","https://media.gemworkers.com/items/9260356e-8f7e-4a62-be2b-67e5abf5a9cd/etsy-8.jpg","https://media.gemworkers.com/items/9260356e-8f7e-4a62-be2b-67e5abf5a9cd/etsy-9.jpg","https://media.gemworkers.com/items/9260356e-8f7e-4a62-be2b-67e5abf5a9cd/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 180 USD, converted at ECB rate. Etsy tags: Jewellery Making,Rings For Women,Jewellery Finding,Rings For Men,Jewels,Gold Rings,Jewellery Supplies,Gift For Her,Natural Stone,Blue tourmaline,lagoon Tourmaline,Oceangemsminerals,AppleGreenTourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('82b505ba-1eb8-4709-b91a-33608fce5f45', '1.70 Cts, Mint Green Tourmaline', 'Mesmerising Mint Green Colour Afghan Tourmaline 

Ethically Sourced, Loupe Clean

Cut To Perfection 

high lustre and brilliance 

1.70 Cts
6.5 x 6 x 5mm

Unheated, No treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 165, 1, 'loose_stone', 'Tourmaline', NULL, 1.7, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/82b505ba-1eb8-4709-b91a-33608fce5f45/etsy-1.jpg","https://media.gemworkers.com/items/82b505ba-1eb8-4709-b91a-33608fce5f45/etsy-2.jpg","https://media.gemworkers.com/items/82b505ba-1eb8-4709-b91a-33608fce5f45/etsy-3.jpg","https://media.gemworkers.com/items/82b505ba-1eb8-4709-b91a-33608fce5f45/etsy-4.jpg","https://media.gemworkers.com/items/82b505ba-1eb8-4709-b91a-33608fce5f45/etsy-5.jpg","https://media.gemworkers.com/items/82b505ba-1eb8-4709-b91a-33608fce5f45/etsy-6.jpg","https://media.gemworkers.com/items/82b505ba-1eb8-4709-b91a-33608fce5f45/etsy-7.jpg","https://media.gemworkers.com/items/82b505ba-1eb8-4709-b91a-33608fce5f45/etsy-8.jpg","https://media.gemworkers.com/items/82b505ba-1eb8-4709-b91a-33608fce5f45/etsy-9.jpg","https://media.gemworkers.com/items/82b505ba-1eb8-4709-b91a-33608fce5f45/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 185 USD, converted at ECB rate. Etsy tags: Jewellery Making,Rings For Women,Jewellery Finding,Rings For Men,Jewels,Gold Rings,Jewellery Supplies,Gift For Her,Natural Stone,Blue tourmaline,lagoon Tourmaline,MintGreen Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('92390f64-dd4c-4fa0-b7ac-a2aae470ba66', '10.55 Cts Green Catseye Tourmaline', 'Gorgeous Mesmerising Green Cool Colour With Cat’s eye Afghan Tourmaline 

better looking in real

10.55 Cts
11.9 x 11.1 x 9.2mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 10.55, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/92390f64-dd4c-4fa0-b7ac-a2aae470ba66/etsy-1.jpg","https://media.gemworkers.com/items/92390f64-dd4c-4fa0-b7ac-a2aae470ba66/etsy-2.jpg","https://media.gemworkers.com/items/92390f64-dd4c-4fa0-b7ac-a2aae470ba66/etsy-3.jpg","https://media.gemworkers.com/items/92390f64-dd4c-4fa0-b7ac-a2aae470ba66/etsy-4.jpg","https://media.gemworkers.com/items/92390f64-dd4c-4fa0-b7ac-a2aae470ba66/etsy-5.jpg","https://media.gemworkers.com/items/92390f64-dd4c-4fa0-b7ac-a2aae470ba66/etsy-6.jpg","https://media.gemworkers.com/items/92390f64-dd4c-4fa0-b7ac-a2aae470ba66/etsy-7.jpg","https://media.gemworkers.com/items/92390f64-dd4c-4fa0-b7ac-a2aae470ba66/etsy-8.jpg","https://media.gemworkers.com/items/92390f64-dd4c-4fa0-b7ac-a2aae470ba66/etsy-9.jpg","https://media.gemworkers.com/items/92390f64-dd4c-4fa0-b7ac-a2aae470ba66/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Jewellery Supplies,Jewellery Making,Jewellery Findings,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Rings For Women,Chrome Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('10f422e3-10d0-4c91-8df9-11491f7122eb', '5.2 Cts Electric Blue Tourmaline', 'Top Electric Blue Colour Tourmaline ✨ 

rare find

5.20 Cts
9.7 x 9 x 7.7mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 447, 1, 'loose_stone', 'Tourmaline', NULL, 5.2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/10f422e3-10d0-4c91-8df9-11491f7122eb/etsy-1.jpg","https://media.gemworkers.com/items/10f422e3-10d0-4c91-8df9-11491f7122eb/etsy-2.jpg","https://media.gemworkers.com/items/10f422e3-10d0-4c91-8df9-11491f7122eb/etsy-3.jpg","https://media.gemworkers.com/items/10f422e3-10d0-4c91-8df9-11491f7122eb/etsy-4.jpg","https://media.gemworkers.com/items/10f422e3-10d0-4c91-8df9-11491f7122eb/etsy-5.jpg","https://media.gemworkers.com/items/10f422e3-10d0-4c91-8df9-11491f7122eb/etsy-6.jpg","https://media.gemworkers.com/items/10f422e3-10d0-4c91-8df9-11491f7122eb/etsy-7.jpg","https://media.gemworkers.com/items/10f422e3-10d0-4c91-8df9-11491f7122eb/etsy-8.jpg","https://media.gemworkers.com/items/10f422e3-10d0-4c91-8df9-11491f7122eb/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 500 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('61a7732a-f586-4541-9b9b-f88adcb43653', '10.80 Cts Mix BiColour Tourmaline Lot', 'Gorgeous Mesmerising Afghan Tourmaline lot,

Unique Colour, glossy and high lustre.

best for jewellery 

10.80 Cts
11.7 to 9.2mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 10.8, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/61a7732a-f586-4541-9b9b-f88adcb43653/etsy-1.jpg","https://media.gemworkers.com/items/61a7732a-f586-4541-9b9b-f88adcb43653/etsy-2.jpg","https://media.gemworkers.com/items/61a7732a-f586-4541-9b9b-f88adcb43653/etsy-3.jpg","https://media.gemworkers.com/items/61a7732a-f586-4541-9b9b-f88adcb43653/etsy-4.jpg","https://media.gemworkers.com/items/61a7732a-f586-4541-9b9b-f88adcb43653/etsy-5.jpg","https://media.gemworkers.com/items/61a7732a-f586-4541-9b9b-f88adcb43653/etsy-6.jpg","https://media.gemworkers.com/items/61a7732a-f586-4541-9b9b-f88adcb43653/etsy-7.jpg","https://media.gemworkers.com/items/61a7732a-f586-4541-9b9b-f88adcb43653/etsy-8.jpg","https://media.gemworkers.com/items/61a7732a-f586-4541-9b9b-f88adcb43653/etsy-9.jpg","https://media.gemworkers.com/items/61a7732a-f586-4541-9b9b-f88adcb43653/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: BlueGreen Tourmaline,Blue Tourmaline,Green Tourmaline,Lagoon Tourmaline,Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery findings,gift for her,natural stone,Oceangemsminerals,apple green colour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('bc2393b9-94f3-40f7-8b42-d9d082eb68b5', '11.6 Cts Deep Blue Tourmaline Lot', 'Gorgeous Deep Blue Mesmerising Afghan Tourmaline Hexagon Cut Lot

Unique And Rare 

11.60 Cts
27.8 to 10.5mm

glowing 

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 11.6, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/bc2393b9-94f3-40f7-8b42-d9d082eb68b5/etsy-1.jpg","https://media.gemworkers.com/items/bc2393b9-94f3-40f7-8b42-d9d082eb68b5/etsy-2.jpg","https://media.gemworkers.com/items/bc2393b9-94f3-40f7-8b42-d9d082eb68b5/etsy-3.jpg","https://media.gemworkers.com/items/bc2393b9-94f3-40f7-8b42-d9d082eb68b5/etsy-4.jpg","https://media.gemworkers.com/items/bc2393b9-94f3-40f7-8b42-d9d082eb68b5/etsy-5.jpg","https://media.gemworkers.com/items/bc2393b9-94f3-40f7-8b42-d9d082eb68b5/etsy-6.jpg","https://media.gemworkers.com/items/bc2393b9-94f3-40f7-8b42-d9d082eb68b5/etsy-7.jpg","https://media.gemworkers.com/items/bc2393b9-94f3-40f7-8b42-d9d082eb68b5/etsy-8.jpg","https://media.gemworkers.com/items/bc2393b9-94f3-40f7-8b42-d9d082eb68b5/etsy-9.jpg","https://media.gemworkers.com/items/bc2393b9-94f3-40f7-8b42-d9d082eb68b5/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Bicolour Tourmaline,Blue Tourmaline,Lagoon Tourmaline,Neon Tourmaline,Tourmaline jewellery,gift for her,natural stone,Tourmaline Rings,tourmaline necklace,rings for men,rings for women,Oceangemsminerals,tourmaline pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('90f6d0ca-79ff-45cb-8ffd-4c7e0afa1bc2', '9.7 Cts Green Hexagon Tourmalines', 'Tourmaline lot  

strong colour, high lustre 

ethically sourced 

9.70 Cts
21.8 to 11mm

 No treatment whatsoever', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 9.7, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/90f6d0ca-79ff-45cb-8ffd-4c7e0afa1bc2/etsy-1.jpg","https://media.gemworkers.com/items/90f6d0ca-79ff-45cb-8ffd-4c7e0afa1bc2/etsy-2.jpg","https://media.gemworkers.com/items/90f6d0ca-79ff-45cb-8ffd-4c7e0afa1bc2/etsy-3.jpg","https://media.gemworkers.com/items/90f6d0ca-79ff-45cb-8ffd-4c7e0afa1bc2/etsy-4.jpg","https://media.gemworkers.com/items/90f6d0ca-79ff-45cb-8ffd-4c7e0afa1bc2/etsy-5.jpg","https://media.gemworkers.com/items/90f6d0ca-79ff-45cb-8ffd-4c7e0afa1bc2/etsy-6.jpg","https://media.gemworkers.com/items/90f6d0ca-79ff-45cb-8ffd-4c7e0afa1bc2/etsy-7.jpg","https://media.gemworkers.com/items/90f6d0ca-79ff-45cb-8ffd-4c7e0afa1bc2/etsy-8.jpg","https://media.gemworkers.com/items/90f6d0ca-79ff-45cb-8ffd-4c7e0afa1bc2/etsy-9.jpg","https://media.gemworkers.com/items/90f6d0ca-79ff-45cb-8ffd-4c7e0afa1bc2/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Tourmaline Earrings,Jewellery Making,Jewellery Findings,y2k earrings stud,Earrings findings,emerald cut,bicolour tourmaline,Tourmaline Pairs,gift for her,Natural Stone,blue tourmaline lot,Oceangemsminerals,Green Tourmaline. Had variations on Etsy — check size/options.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('55bbdaff-0829-4dea-a354-46c951c26573', '5.55 Cts Tourmaline Pairs for Earrings', 'A Very High Lustre Unique Colour Tourmaline Set For Earrings 

High Quality Fine Cut

5.55 Cts
7.6 x 6 x 5.2mm
6.4 x 4.3 x 3.4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'jewelry', 'Tourmaline', NULL, 5.55, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/55bbdaff-0829-4dea-a354-46c951c26573/etsy-1.jpg","https://media.gemworkers.com/items/55bbdaff-0829-4dea-a354-46c951c26573/etsy-2.jpg","https://media.gemworkers.com/items/55bbdaff-0829-4dea-a354-46c951c26573/etsy-3.jpg","https://media.gemworkers.com/items/55bbdaff-0829-4dea-a354-46c951c26573/etsy-4.jpg","https://media.gemworkers.com/items/55bbdaff-0829-4dea-a354-46c951c26573/etsy-5.jpg","https://media.gemworkers.com/items/55bbdaff-0829-4dea-a354-46c951c26573/etsy-6.jpg","https://media.gemworkers.com/items/55bbdaff-0829-4dea-a354-46c951c26573/etsy-7.jpg","https://media.gemworkers.com/items/55bbdaff-0829-4dea-a354-46c951c26573/etsy-8.jpg","https://media.gemworkers.com/items/55bbdaff-0829-4dea-a354-46c951c26573/etsy-9.jpg","https://media.gemworkers.com/items/55bbdaff-0829-4dea-a354-46c951c26573/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Tourmaline Earrings,Earrings Set,Fine Tourmaline,Canary Tourmaline,Lagoon Tourmaline,Blue Tourmaline,Yellow Tourmaline,Stud Earrings,Tourmaline Jewellery,Jewellery Set,Oceangemsminerals,Tourmaline Pairs,Lagoon Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('56192bce-ab6e-43c7-b11b-2c15a84ecbda', '4.50 Cts Hessonite Garnet', 'Gorgeous cushion cut Hessonite garnet 

More beautiful in real 

Excellent cut and polish 

4.50 Cts
10 x 7 x 5mm

Unheated untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 89, 1, 'loose_stone', 'Garnet', NULL, 4.5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/56192bce-ab6e-43c7-b11b-2c15a84ecbda/etsy-1.jpg","https://media.gemworkers.com/items/56192bce-ab6e-43c7-b11b-2c15a84ecbda/etsy-2.jpg","https://media.gemworkers.com/items/56192bce-ab6e-43c7-b11b-2c15a84ecbda/etsy-3.jpg","https://media.gemworkers.com/items/56192bce-ab6e-43c7-b11b-2c15a84ecbda/etsy-4.jpg","https://media.gemworkers.com/items/56192bce-ab6e-43c7-b11b-2c15a84ecbda/etsy-5.jpg","https://media.gemworkers.com/items/56192bce-ab6e-43c7-b11b-2c15a84ecbda/etsy-6.jpg","https://media.gemworkers.com/items/56192bce-ab6e-43c7-b11b-2c15a84ecbda/etsy-7.jpg","https://media.gemworkers.com/items/56192bce-ab6e-43c7-b11b-2c15a84ecbda/etsy-8.jpg","https://media.gemworkers.com/items/56192bce-ab6e-43c7-b11b-2c15a84ecbda/etsy-9.jpg","https://media.gemworkers.com/items/56192bce-ab6e-43c7-b11b-2c15a84ecbda/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 100 USD, converted at ECB rate. Etsy tags: garnet,hessonite garnet,faceted garnet,red garnet,garnet jewellery,garnet ring,natural stone,jewellery making,jewellery supplies,jewellery findings,gift for her,orange garnet,ring for women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('52e0e14e-c927-4b99-8a93-cea9ad2835b7', '8.20 Cts Hessonite Garnet', 'Gorgeous cushion cut Hessonite garnet 

More beautiful in real 

Excellent cut and polish 

8.20 Cts
11.9 x 7 x 5mm

Unheated untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 134, 1, 'loose_stone', 'Garnet', NULL, 8.2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/52e0e14e-c927-4b99-8a93-cea9ad2835b7/etsy-1.jpg","https://media.gemworkers.com/items/52e0e14e-c927-4b99-8a93-cea9ad2835b7/etsy-2.jpg","https://media.gemworkers.com/items/52e0e14e-c927-4b99-8a93-cea9ad2835b7/etsy-3.jpg","https://media.gemworkers.com/items/52e0e14e-c927-4b99-8a93-cea9ad2835b7/etsy-4.jpg","https://media.gemworkers.com/items/52e0e14e-c927-4b99-8a93-cea9ad2835b7/etsy-5.jpg","https://media.gemworkers.com/items/52e0e14e-c927-4b99-8a93-cea9ad2835b7/etsy-6.jpg","https://media.gemworkers.com/items/52e0e14e-c927-4b99-8a93-cea9ad2835b7/etsy-7.jpg","https://media.gemworkers.com/items/52e0e14e-c927-4b99-8a93-cea9ad2835b7/etsy-8.jpg","https://media.gemworkers.com/items/52e0e14e-c927-4b99-8a93-cea9ad2835b7/etsy-9.jpg","https://media.gemworkers.com/items/52e0e14e-c927-4b99-8a93-cea9ad2835b7/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 150 USD, converted at ECB rate. Etsy tags: garnet,hessonite garnet,faceted garnet,red garnet,garnet jewellery,garnet ring,natural stone,jewellery making,jewellery supplies,jewellery findings,gift for her,orange garnet,ring for women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('a9c85550-de6a-43f9-a6fc-e2f84068868a', '4 Cts Blue Green Tourmaline', 'Gorgeous Mesmerising Blue Green Afghan Tourmaline 

Unique Colour 

4 Cts
9 x 7 x 6.5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 89, 1, 'loose_stone', 'Tourmaline', NULL, 4, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/a9c85550-de6a-43f9-a6fc-e2f84068868a/etsy-1.jpg","https://media.gemworkers.com/items/a9c85550-de6a-43f9-a6fc-e2f84068868a/etsy-2.jpg","https://media.gemworkers.com/items/a9c85550-de6a-43f9-a6fc-e2f84068868a/etsy-3.jpg","https://media.gemworkers.com/items/a9c85550-de6a-43f9-a6fc-e2f84068868a/etsy-4.jpg","https://media.gemworkers.com/items/a9c85550-de6a-43f9-a6fc-e2f84068868a/etsy-5.jpg","https://media.gemworkers.com/items/a9c85550-de6a-43f9-a6fc-e2f84068868a/etsy-6.jpg","https://media.gemworkers.com/items/a9c85550-de6a-43f9-a6fc-e2f84068868a/etsy-7.jpg","https://media.gemworkers.com/items/a9c85550-de6a-43f9-a6fc-e2f84068868a/etsy-8.jpg","https://media.gemworkers.com/items/a9c85550-de6a-43f9-a6fc-e2f84068868a/etsy-9.jpg","https://media.gemworkers.com/items/a9c85550-de6a-43f9-a6fc-e2f84068868a/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 100 USD, converted at ECB rate. Etsy tags: BlueGreen Tourmaline,Blue Tourmaline,Green Tourmaline,Lagoon Tourmaline,Neon Tourmaline,Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery supplies,jewellery findings,gift for her,natural stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('706d23da-1394-46b6-bbcb-b06f4b235be0', 'Blue Tourmaline 1.65 Cts', 'Sapphire is expensive 

Here I bring You The Sapphire Like Colour Afghan Tourmaline 

High Lustre, Vibrant Blue Colour 

This Is something not to be missed its a rare find

1.65 carats 

7.2 x 4 x 3mm
6.7 x 4.5 x 3.2mm

No treatment whatsoever', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 1.65, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/706d23da-1394-46b6-bbcb-b06f4b235be0/etsy-1.jpg","https://media.gemworkers.com/items/706d23da-1394-46b6-bbcb-b06f4b235be0/etsy-2.jpg","https://media.gemworkers.com/items/706d23da-1394-46b6-bbcb-b06f4b235be0/etsy-3.jpg","https://media.gemworkers.com/items/706d23da-1394-46b6-bbcb-b06f4b235be0/etsy-4.jpg","https://media.gemworkers.com/items/706d23da-1394-46b6-bbcb-b06f4b235be0/etsy-5.jpg","https://media.gemworkers.com/items/706d23da-1394-46b6-bbcb-b06f4b235be0/etsy-6.jpg","https://media.gemworkers.com/items/706d23da-1394-46b6-bbcb-b06f4b235be0/etsy-7.jpg","https://media.gemworkers.com/items/706d23da-1394-46b6-bbcb-b06f4b235be0/etsy-8.jpg","https://media.gemworkers.com/items/706d23da-1394-46b6-bbcb-b06f4b235be0/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Jewellery Making,Jewellery Supplies,Jewellery Findings,Tourmaline Rings,Tourmaline Jewellery,Rings Findings,Gold Rings,Natural Stone,Blue Tourmaline,Sapphire Blue,Gift For Her,Handmade,y2k earrings stud.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('d95b2b01-4a19-4552-b892-6db4306a9305', 'Blue Tourmaline 1.60 Cts', 'Sapphire is expensive 

Here I bring You The Sapphire Like Colour Afghan Tourmaline 

High Lustre, Vibrant Blue Colour 

This Is something not to be missed its a rare find

1.60 carats 

5 x 5 x 4
5 x 3 x 3

No treatment whatsoever', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 1.6, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/d95b2b01-4a19-4552-b892-6db4306a9305/etsy-1.jpg","https://media.gemworkers.com/items/d95b2b01-4a19-4552-b892-6db4306a9305/etsy-2.jpg","https://media.gemworkers.com/items/d95b2b01-4a19-4552-b892-6db4306a9305/etsy-3.jpg","https://media.gemworkers.com/items/d95b2b01-4a19-4552-b892-6db4306a9305/etsy-4.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Jewellery Making,Jewellery Supplies,Jewellery Findings,Tourmaline Rings,Tourmaline Jewellery,Rings Findings,Gold Rings,Natural Stone,Blue Tourmaline,Sapphire Blue,Gift For Her,Handmade,y2k earrings stud.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('d2b8db78-dc35-4fb2-8320-36de92888102', '3.30 Cts Rubilite Tourmalines', 'Gorgeous Rubilite Tourmalines

3.30 Cts
7.5 x 5 x 3mm
6 x 4 x 3mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', 'Rubellite', 3.3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/d2b8db78-dc35-4fb2-8320-36de92888102/etsy-1.jpg","https://media.gemworkers.com/items/d2b8db78-dc35-4fb2-8320-36de92888102/etsy-2.jpg","https://media.gemworkers.com/items/d2b8db78-dc35-4fb2-8320-36de92888102/etsy-3.jpg","https://media.gemworkers.com/items/d2b8db78-dc35-4fb2-8320-36de92888102/etsy-4.jpg","https://media.gemworkers.com/items/d2b8db78-dc35-4fb2-8320-36de92888102/etsy-5.jpg","https://media.gemworkers.com/items/d2b8db78-dc35-4fb2-8320-36de92888102/etsy-6.jpg","https://media.gemworkers.com/items/d2b8db78-dc35-4fb2-8320-36de92888102/etsy-7.jpg","https://media.gemworkers.com/items/d2b8db78-dc35-4fb2-8320-36de92888102/etsy-8.jpg","https://media.gemworkers.com/items/d2b8db78-dc35-4fb2-8320-36de92888102/etsy-9.jpg","https://media.gemworkers.com/items/d2b8db78-dc35-4fb2-8320-36de92888102/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('b869acf5-e1be-4124-8c65-38635dbd6966', '10.80 Cts Blue Tourmaline Lot', 'Blue and Teal Blue Colour Tourmaline Lot

One of a kind, top colours and and clarity.

10.80 Cts
6.9 to 9.6mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 339, 1, 'loose_stone', 'Tourmaline', NULL, 10.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/b869acf5-e1be-4124-8c65-38635dbd6966/etsy-1.jpg","https://media.gemworkers.com/items/b869acf5-e1be-4124-8c65-38635dbd6966/etsy-2.jpg","https://media.gemworkers.com/items/b869acf5-e1be-4124-8c65-38635dbd6966/etsy-3.jpg","https://media.gemworkers.com/items/b869acf5-e1be-4124-8c65-38635dbd6966/etsy-4.jpg","https://media.gemworkers.com/items/b869acf5-e1be-4124-8c65-38635dbd6966/etsy-5.jpg","https://media.gemworkers.com/items/b869acf5-e1be-4124-8c65-38635dbd6966/etsy-6.jpg","https://media.gemworkers.com/items/b869acf5-e1be-4124-8c65-38635dbd6966/etsy-7.jpg","https://media.gemworkers.com/items/b869acf5-e1be-4124-8c65-38635dbd6966/etsy-8.jpg","https://media.gemworkers.com/items/b869acf5-e1be-4124-8c65-38635dbd6966/etsy-9.jpg","https://media.gemworkers.com/items/b869acf5-e1be-4124-8c65-38635dbd6966/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 380 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('392fceb5-3985-401d-8936-4ecf41dddb79', '7 Cts Blue Tourmaline Lot', 'Blue and Teal Blue Colour Tourmaline Lot

One of a kind, top colours and and clarity.

7 Cts
4.2 to 6.2mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 250, 1, 'loose_stone', 'Tourmaline', NULL, 7, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/392fceb5-3985-401d-8936-4ecf41dddb79/etsy-1.jpg","https://media.gemworkers.com/items/392fceb5-3985-401d-8936-4ecf41dddb79/etsy-2.jpg","https://media.gemworkers.com/items/392fceb5-3985-401d-8936-4ecf41dddb79/etsy-3.jpg","https://media.gemworkers.com/items/392fceb5-3985-401d-8936-4ecf41dddb79/etsy-4.jpg","https://media.gemworkers.com/items/392fceb5-3985-401d-8936-4ecf41dddb79/etsy-5.jpg","https://media.gemworkers.com/items/392fceb5-3985-401d-8936-4ecf41dddb79/etsy-6.jpg","https://media.gemworkers.com/items/392fceb5-3985-401d-8936-4ecf41dddb79/etsy-7.jpg","https://media.gemworkers.com/items/392fceb5-3985-401d-8936-4ecf41dddb79/etsy-8.jpg","https://media.gemworkers.com/items/392fceb5-3985-401d-8936-4ecf41dddb79/etsy-9.jpg","https://media.gemworkers.com/items/392fceb5-3985-401d-8936-4ecf41dddb79/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 280 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('34942147-b677-4c6e-8367-7edabdc736e4', '5 Cts Unique Tourmalines', 'Blue Green, Canary, And Seafoam colour Afghan tourmaline 

ETHICALLY SOURCED 

best for jewellery 
vibrant colours


5 carats 

Size:5.4x4.6x3.6mm to 6.8x6.3x4.8mm

no treatment whatsoever', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 5, 'ct', 'Afghanistan', NULL, '5.4x4.6x3.6', '["https://media.gemworkers.com/items/34942147-b677-4c6e-8367-7edabdc736e4/etsy-1.jpg","https://media.gemworkers.com/items/34942147-b677-4c6e-8367-7edabdc736e4/etsy-2.jpg","https://media.gemworkers.com/items/34942147-b677-4c6e-8367-7edabdc736e4/etsy-3.jpg","https://media.gemworkers.com/items/34942147-b677-4c6e-8367-7edabdc736e4/etsy-4.jpg","https://media.gemworkers.com/items/34942147-b677-4c6e-8367-7edabdc736e4/etsy-5.jpg","https://media.gemworkers.com/items/34942147-b677-4c6e-8367-7edabdc736e4/etsy-6.jpg","https://media.gemworkers.com/items/34942147-b677-4c6e-8367-7edabdc736e4/etsy-7.jpg","https://media.gemworkers.com/items/34942147-b677-4c6e-8367-7edabdc736e4/etsy-8.jpg","https://media.gemworkers.com/items/34942147-b677-4c6e-8367-7edabdc736e4/etsy-9.jpg","https://media.gemworkers.com/items/34942147-b677-4c6e-8367-7edabdc736e4/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Jewellery Supplies,jewellery Findings,Tourmaline Jewellery,Tourmaline earrings,Earrings Making,Gift For Her,Natural Stone,Rings For Men,Rings For Women,Tourmaline Lot,Green Tourmaline,Purple Tourmaline,Canary Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('0360c10e-1ddd-4e6b-a0b3-55daddd16382', 'Peach Pink Tourmaline 2.25 Cts', 'Mesmerising Peach Pink Colour Tourmaline 

Cut to perfection, Lustre And Brilliance 

Eye Clean

2.25 carats 
9 x 6.5 x 4mm

Unheated,Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 130, 1, 'loose_stone', 'Tourmaline', NULL, 2.25, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/0360c10e-1ddd-4e6b-a0b3-55daddd16382/etsy-1.jpg","https://media.gemworkers.com/items/0360c10e-1ddd-4e6b-a0b3-55daddd16382/etsy-2.jpg","https://media.gemworkers.com/items/0360c10e-1ddd-4e6b-a0b3-55daddd16382/etsy-3.jpg","https://media.gemworkers.com/items/0360c10e-1ddd-4e6b-a0b3-55daddd16382/etsy-4.jpg","https://media.gemworkers.com/items/0360c10e-1ddd-4e6b-a0b3-55daddd16382/etsy-5.jpg","https://media.gemworkers.com/items/0360c10e-1ddd-4e6b-a0b3-55daddd16382/etsy-6.jpg","https://media.gemworkers.com/items/0360c10e-1ddd-4e6b-a0b3-55daddd16382/etsy-7.jpg","https://media.gemworkers.com/items/0360c10e-1ddd-4e6b-a0b3-55daddd16382/etsy-8.jpg","https://media.gemworkers.com/items/0360c10e-1ddd-4e6b-a0b3-55daddd16382/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 145 USD, converted at ECB rate. Etsy tags: Gold Rings,Tourmaline Rings,Tourmaline Jewellery,Stud Rings,Rings For Women,Rings For Men,Jewellery Making,jewellery supplies,jewellery findings,y2k rings stud,loose gemstone,jewels,cushion.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('21d04ccd-40a2-4aed-a145-4e3b3df3d636', '3 Cts Tourmalines', 'A Very High Lustre Unique Colour Tourmalines

High Quality Fine Cut

3 Cts
6.5 x 5.8 x 4.7mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 89, 1, 'loose_stone', 'Tourmaline', NULL, 3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/21d04ccd-40a2-4aed-a145-4e3b3df3d636/etsy-1.jpg","https://media.gemworkers.com/items/21d04ccd-40a2-4aed-a145-4e3b3df3d636/etsy-2.jpg","https://media.gemworkers.com/items/21d04ccd-40a2-4aed-a145-4e3b3df3d636/etsy-3.jpg","https://media.gemworkers.com/items/21d04ccd-40a2-4aed-a145-4e3b3df3d636/etsy-4.jpg","https://media.gemworkers.com/items/21d04ccd-40a2-4aed-a145-4e3b3df3d636/etsy-5.jpg","https://media.gemworkers.com/items/21d04ccd-40a2-4aed-a145-4e3b3df3d636/etsy-6.jpg","https://media.gemworkers.com/items/21d04ccd-40a2-4aed-a145-4e3b3df3d636/etsy-7.jpg","https://media.gemworkers.com/items/21d04ccd-40a2-4aed-a145-4e3b3df3d636/etsy-8.jpg","https://media.gemworkers.com/items/21d04ccd-40a2-4aed-a145-4e3b3df3d636/etsy-9.jpg","https://media.gemworkers.com/items/21d04ccd-40a2-4aed-a145-4e3b3df3d636/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 100 USD, converted at ECB rate. Etsy tags: Tourmaline Earrings,Earrings Set,Fine Tourmaline,Canary Tourmaline,Lagoon Tourmaline,Blue Tourmaline,Yellow Tourmaline,Stud Earrings,Tourmaline Jewellery,Jewellery Set,Oceangemsminerals,Tourmaline Pairs,Lagoon Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('38d97e5a-bca0-46ad-bab2-352150c01bf6', '54.9 Cts Aquamarine Cabochon', 'big size Aquamarine Cabochon 

ethically sourced 

54.90 carats 

Dimension:20x19x16mm

unheated, untreated m.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 107, 1, 'loose_stone', 'Aquamarine', NULL, 54.9, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/38d97e5a-bca0-46ad-bab2-352150c01bf6/etsy-1.jpg","https://media.gemworkers.com/items/38d97e5a-bca0-46ad-bab2-352150c01bf6/etsy-2.jpg","https://media.gemworkers.com/items/38d97e5a-bca0-46ad-bab2-352150c01bf6/etsy-3.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 120 USD, converted at ECB rate. Etsy tags: Santa Maria Cabochon,Blue Aquamarine,Unique Aquamarine,Rare Aquamarine,Aquamarine Cabochons,Bicolour Aquamarine,Bicolour Cabochons,Blue Cabochons,Lagoon Cabochons,Natural Stone,jewels,Oceangemsminerals,Rare Cabochons.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('fdc31b1c-2462-4fc3-9e10-87c97de89597', '39 Cts Aquamarine Cabochon', 'big size Aquamarine Cabochon 

ethically sourced 

39.20 carats 

Dimension:25x12x11.5mm

unheated, untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 89, 1, 'loose_stone', 'Aquamarine', NULL, 39, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/fdc31b1c-2462-4fc3-9e10-87c97de89597/etsy-1.jpg","https://media.gemworkers.com/items/fdc31b1c-2462-4fc3-9e10-87c97de89597/etsy-2.jpg","https://media.gemworkers.com/items/fdc31b1c-2462-4fc3-9e10-87c97de89597/etsy-3.jpg","https://media.gemworkers.com/items/fdc31b1c-2462-4fc3-9e10-87c97de89597/etsy-4.jpg","https://media.gemworkers.com/items/fdc31b1c-2462-4fc3-9e10-87c97de89597/etsy-5.jpg","https://media.gemworkers.com/items/fdc31b1c-2462-4fc3-9e10-87c97de89597/etsy-6.jpg","https://media.gemworkers.com/items/fdc31b1c-2462-4fc3-9e10-87c97de89597/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 100 USD, converted at ECB rate. Etsy tags: Santa Maria Cabochon,Blue Aquamarine,Unique Aquamarine,Rare Aquamarine,Aquamarine Cabochons,Bicolour Aquamarine,Bicolour Cabochons,Blue Cabochons,Lagoon Cabochons,Natural Stone,jewels,Oceangemsminerals,Rare Cabochons.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('332ba230-1497-49eb-9d3f-561267856965', 'Chrome Green Tourmaline, 3.70 Cts', 'Gorgeous Mesmerising Chrome Green Cool Colour Afghan Tourmaline 

One Of A Kind

3.70 carats 
11x7x5.5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 232, 1, 'loose_stone', 'Tourmaline', NULL, 3.7, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/332ba230-1497-49eb-9d3f-561267856965/etsy-1.jpg","https://media.gemworkers.com/items/332ba230-1497-49eb-9d3f-561267856965/etsy-2.jpg","https://media.gemworkers.com/items/332ba230-1497-49eb-9d3f-561267856965/etsy-3.jpg","https://media.gemworkers.com/items/332ba230-1497-49eb-9d3f-561267856965/etsy-4.jpg","https://media.gemworkers.com/items/332ba230-1497-49eb-9d3f-561267856965/etsy-5.jpg","https://media.gemworkers.com/items/332ba230-1497-49eb-9d3f-561267856965/etsy-6.jpg","https://media.gemworkers.com/items/332ba230-1497-49eb-9d3f-561267856965/etsy-7.jpg","https://media.gemworkers.com/items/332ba230-1497-49eb-9d3f-561267856965/etsy-8.jpg","https://media.gemworkers.com/items/332ba230-1497-49eb-9d3f-561267856965/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 260 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Jewellery Supplies,Jewellery Making,Jewellery Findings,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Rings For Women,Chrome Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('5458c3d6-6515-462c-8a83-75a84962eb44', '37.60 Cts Bicolour Tourmaline Rosecuts lot', 'Gorgeous Bicolour Tourmaline Rosecuts Lot

 Nice Polished

37.60 Cts
5 to 16mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 161, 1, 'loose_stone', 'Tourmaline', NULL, 37.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/5458c3d6-6515-462c-8a83-75a84962eb44/etsy-1.jpg","https://media.gemworkers.com/items/5458c3d6-6515-462c-8a83-75a84962eb44/etsy-2.jpg","https://media.gemworkers.com/items/5458c3d6-6515-462c-8a83-75a84962eb44/etsy-3.jpg","https://media.gemworkers.com/items/5458c3d6-6515-462c-8a83-75a84962eb44/etsy-4.jpg","https://media.gemworkers.com/items/5458c3d6-6515-462c-8a83-75a84962eb44/etsy-5.jpg","https://media.gemworkers.com/items/5458c3d6-6515-462c-8a83-75a84962eb44/etsy-6.jpg","https://media.gemworkers.com/items/5458c3d6-6515-462c-8a83-75a84962eb44/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 180 USD, converted at ECB rate. Etsy tags: Santa Maria Cabochon,Unique Aquamarine,Bicolour Aquamarine,Bicolour Cabochons,Blue Cabochons,Lagoon Cabochons,Natural Stone,jewels,Oceangemsminerals,Tourmaline Rosecuts,Lagoon Rosecuts,Blue Tourmaline,Blue Rosecuts.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('38109e65-7e05-45d1-b420-c359ebba1acd', 'Unique Tourmaline Lot 2.4 Cts', 'Neon Green, Purple, And pink colour Afghan tourmaline 

ETHICALLY SOURCED 

best for jewellery 
vibrant colours


Weight:2.40 carat 
Size:4.9mm to 5.1mmmm

no treatment whatsoever', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 134, 1, 'loose_stone', 'Tourmaline', NULL, 2.4, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/38109e65-7e05-45d1-b420-c359ebba1acd/etsy-1.jpg","https://media.gemworkers.com/items/38109e65-7e05-45d1-b420-c359ebba1acd/etsy-2.jpg","https://media.gemworkers.com/items/38109e65-7e05-45d1-b420-c359ebba1acd/etsy-3.jpg","https://media.gemworkers.com/items/38109e65-7e05-45d1-b420-c359ebba1acd/etsy-4.jpg","https://media.gemworkers.com/items/38109e65-7e05-45d1-b420-c359ebba1acd/etsy-5.jpg","https://media.gemworkers.com/items/38109e65-7e05-45d1-b420-c359ebba1acd/etsy-6.jpg","https://media.gemworkers.com/items/38109e65-7e05-45d1-b420-c359ebba1acd/etsy-7.jpg","https://media.gemworkers.com/items/38109e65-7e05-45d1-b420-c359ebba1acd/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 150 USD, converted at ECB rate. Etsy tags: Jewellery Making,Jewellery Supplies,jewellery Findings,Tourmaline Jewellery,Tourmaline earrings,Earrings Making,Gift For Her,Natural Stone,Rings For Men,Rings For Women,Tourmaline Lot,Green Tourmaline,Purple Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('329bcb32-82df-416e-9615-24cb6665a1bb', 'Blue bicolour tourmaline, 1.70 Cts', 'Unique Blue Bicolour Tourmaline 

1.70 Cts
10 x 4.5 x 3mm

no treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 89, 1, 'loose_stone', 'Tourmaline', NULL, 1.7, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/329bcb32-82df-416e-9615-24cb6665a1bb/etsy-1.jpg","https://media.gemworkers.com/items/329bcb32-82df-416e-9615-24cb6665a1bb/etsy-2.jpg","https://media.gemworkers.com/items/329bcb32-82df-416e-9615-24cb6665a1bb/etsy-3.jpg","https://media.gemworkers.com/items/329bcb32-82df-416e-9615-24cb6665a1bb/etsy-4.jpg","https://media.gemworkers.com/items/329bcb32-82df-416e-9615-24cb6665a1bb/etsy-5.jpg","https://media.gemworkers.com/items/329bcb32-82df-416e-9615-24cb6665a1bb/etsy-6.jpg","https://media.gemworkers.com/items/329bcb32-82df-416e-9615-24cb6665a1bb/etsy-7.jpg","https://media.gemworkers.com/items/329bcb32-82df-416e-9615-24cb6665a1bb/etsy-8.jpg","https://media.gemworkers.com/items/329bcb32-82df-416e-9615-24cb6665a1bb/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 100 USD, converted at ECB rate. Etsy tags: Blue Bicolour,Bicolour Tourmaline,Blue Tourmaline,Lavender Tourmaline,Purple Tourmaline,Lagoon tourmaline,neon blue tourmaline,jewellery making,jewellery findings,jewellery supplies,gift for her,Natural stone,Handmadejewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('cd60fec8-92ad-4bec-9325-220cac64b356', 'Tourmaline Lot 10 Cts', 'Mix Green Colour tourmaline lot
for jewellery use

the ice blue ones are really special, worth more than the whole lot.

Weight:10 carat
Size:5mm to 11mm long

no treatment', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 143, 1, 'loose_stone', 'Tourmaline', NULL, 10, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/cd60fec8-92ad-4bec-9325-220cac64b356/etsy-1.jpg","https://media.gemworkers.com/items/cd60fec8-92ad-4bec-9325-220cac64b356/etsy-2.jpg","https://media.gemworkers.com/items/cd60fec8-92ad-4bec-9325-220cac64b356/etsy-3.jpg","https://media.gemworkers.com/items/cd60fec8-92ad-4bec-9325-220cac64b356/etsy-4.jpg","https://media.gemworkers.com/items/cd60fec8-92ad-4bec-9325-220cac64b356/etsy-5.jpg","https://media.gemworkers.com/items/cd60fec8-92ad-4bec-9325-220cac64b356/etsy-6.jpg","https://media.gemworkers.com/items/cd60fec8-92ad-4bec-9325-220cac64b356/etsy-7.jpg","https://media.gemworkers.com/items/cd60fec8-92ad-4bec-9325-220cac64b356/etsy-8.jpg","https://media.gemworkers.com/items/cd60fec8-92ad-4bec-9325-220cac64b356/etsy-9.jpg","https://media.gemworkers.com/items/cd60fec8-92ad-4bec-9325-220cac64b356/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 160 USD, converted at ECB rate. Etsy tags: loose gemstones,tourmaline jewellery,tourmaline lots,green tourmaline,jewellery making,jewellery supplies,jewellery findings,gift for her,natural stone,emerald cut,mint Green tourmalin,y2k earrings stud,blue tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('c42fc0fd-de62-4bee-97a9-08b8bf003ad0', 'Green Colour Tourmaline 2.4 Cts', 'Unique Green Colour Afghan Tourmaline 

Cut to perfection, Brilliance And Lustre 

Ethically sourced 
Clarity: eye clean 

2.40 carats 
7 x 7 x 6mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 125, 1, 'loose_stone', 'Tourmaline', NULL, 2.4, 'ct', 'Afghanistan', 'eye clean', NULL, '["https://media.gemworkers.com/items/c42fc0fd-de62-4bee-97a9-08b8bf003ad0/etsy-1.jpg","https://media.gemworkers.com/items/c42fc0fd-de62-4bee-97a9-08b8bf003ad0/etsy-2.jpg","https://media.gemworkers.com/items/c42fc0fd-de62-4bee-97a9-08b8bf003ad0/etsy-3.jpg","https://media.gemworkers.com/items/c42fc0fd-de62-4bee-97a9-08b8bf003ad0/etsy-4.jpg","https://media.gemworkers.com/items/c42fc0fd-de62-4bee-97a9-08b8bf003ad0/etsy-5.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 140 USD, converted at ECB rate. Etsy tags: Jewellery Making,Jewellery Findings,Jewellery Supplies,Gold Rings,Gift For Her,Rings For Women,Rings For Men,Tourmaline Jewellery,Tourmaline Ring,Green Tourmaline,Tourmaline Supplies,Tourmaline Earrings,y2k earrings stud.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('bc071d68-003c-45b0-aa8c-b464b25cb153', '4.9 Cts Panjsher Emerald Lot', 'Gorgeous Emerald Lot From Panjsher

Colour is more beautiful in real 

4.90 Cts
7 to 5.1mm

Unheated, untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 231, 1, 'loose_stone', 'Emerald', NULL, 4.9, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/bc071d68-003c-45b0-aa8c-b464b25cb153/etsy-1.jpg","https://media.gemworkers.com/items/bc071d68-003c-45b0-aa8c-b464b25cb153/etsy-2.jpg","https://media.gemworkers.com/items/bc071d68-003c-45b0-aa8c-b464b25cb153/etsy-3.jpg","https://media.gemworkers.com/items/bc071d68-003c-45b0-aa8c-b464b25cb153/etsy-4.jpg","https://media.gemworkers.com/items/bc071d68-003c-45b0-aa8c-b464b25cb153/etsy-5.jpg","https://media.gemworkers.com/items/bc071d68-003c-45b0-aa8c-b464b25cb153/etsy-6.jpg","https://media.gemworkers.com/items/bc071d68-003c-45b0-aa8c-b464b25cb153/etsy-7.jpg","https://media.gemworkers.com/items/bc071d68-003c-45b0-aa8c-b464b25cb153/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 258 USD, converted at ECB rate. Etsy tags: Emerald,Emerald supplies,Emerald rings,Emerald earrings,Oceangemsminerals,Gift for her,Natural stone,Jewellery making,Rings for women,Rings for men,Emerald Jewellery,Bicolour Emerald,Emerald Cabochons.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('73b07f2e-a44b-4340-81d1-2856c1e6838b', '18.8 Cts Panjsher Emerald Lot', 'Gorgeous Emerald Lot From Panjsher

Colour is more beautiful in real 

18.8 Cts
10 to 5.6mm

Unheated, untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 402, 1, 'loose_stone', 'Emerald', NULL, 18.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/73b07f2e-a44b-4340-81d1-2856c1e6838b/etsy-1.jpg","https://media.gemworkers.com/items/73b07f2e-a44b-4340-81d1-2856c1e6838b/etsy-2.jpg","https://media.gemworkers.com/items/73b07f2e-a44b-4340-81d1-2856c1e6838b/etsy-3.jpg","https://media.gemworkers.com/items/73b07f2e-a44b-4340-81d1-2856c1e6838b/etsy-4.jpg","https://media.gemworkers.com/items/73b07f2e-a44b-4340-81d1-2856c1e6838b/etsy-5.jpg","https://media.gemworkers.com/items/73b07f2e-a44b-4340-81d1-2856c1e6838b/etsy-6.jpg","https://media.gemworkers.com/items/73b07f2e-a44b-4340-81d1-2856c1e6838b/etsy-7.jpg","https://media.gemworkers.com/items/73b07f2e-a44b-4340-81d1-2856c1e6838b/etsy-8.jpg","https://media.gemworkers.com/items/73b07f2e-a44b-4340-81d1-2856c1e6838b/etsy-9.jpg","https://media.gemworkers.com/items/73b07f2e-a44b-4340-81d1-2856c1e6838b/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 450 USD, converted at ECB rate. Etsy tags: Emerald,Emerald supplies,Emerald rings,Emerald earrings,Oceangemsminerals,Gift for her,Natural stone,Jewellery making,Rings for women,Rings for men,Emerald Jewellery,Bicolour Emerald,Emerald Cabochons.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('5b6d82a6-582d-4aac-bd6f-09a4a425de33', '11.65 Cts Panjsher Emerald Lot', 'Gorgeous Emerald Lot From Panjsher

Colour is more beautiful in real 

11.65 Cts
9.1 to 4.5mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Emerald', NULL, 11.65, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/5b6d82a6-582d-4aac-bd6f-09a4a425de33/etsy-1.jpg","https://media.gemworkers.com/items/5b6d82a6-582d-4aac-bd6f-09a4a425de33/etsy-2.jpg","https://media.gemworkers.com/items/5b6d82a6-582d-4aac-bd6f-09a4a425de33/etsy-3.jpg","https://media.gemworkers.com/items/5b6d82a6-582d-4aac-bd6f-09a4a425de33/etsy-4.jpg","https://media.gemworkers.com/items/5b6d82a6-582d-4aac-bd6f-09a4a425de33/etsy-5.jpg","https://media.gemworkers.com/items/5b6d82a6-582d-4aac-bd6f-09a4a425de33/etsy-6.jpg","https://media.gemworkers.com/items/5b6d82a6-582d-4aac-bd6f-09a4a425de33/etsy-7.jpg","https://media.gemworkers.com/items/5b6d82a6-582d-4aac-bd6f-09a4a425de33/etsy-8.jpg","https://media.gemworkers.com/items/5b6d82a6-582d-4aac-bd6f-09a4a425de33/etsy-9.jpg","https://media.gemworkers.com/items/5b6d82a6-582d-4aac-bd6f-09a4a425de33/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Emerald,Emerald supplies,Emerald rings,Emerald earrings,Oceangemsminerals,Gift for her,Natural stone,Jewellery making,Rings for women,Rings for men,Emerald Jewellery,Bicolour Emerald,Emerald Cabochons.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('65974e2c-1041-4c24-b0d6-1c0f3667d93a', '12.55 Cts Panjsher Emerald Lot', 'Gorgeous Emerald Lot From Panjsher

Colour is more beautiful in real 

12.55 Cts
7.2 to 5mm

Unheated,', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Emerald', NULL, 12.55, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/65974e2c-1041-4c24-b0d6-1c0f3667d93a/etsy-1.jpg","https://media.gemworkers.com/items/65974e2c-1041-4c24-b0d6-1c0f3667d93a/etsy-2.jpg","https://media.gemworkers.com/items/65974e2c-1041-4c24-b0d6-1c0f3667d93a/etsy-3.jpg","https://media.gemworkers.com/items/65974e2c-1041-4c24-b0d6-1c0f3667d93a/etsy-4.jpg","https://media.gemworkers.com/items/65974e2c-1041-4c24-b0d6-1c0f3667d93a/etsy-5.jpg","https://media.gemworkers.com/items/65974e2c-1041-4c24-b0d6-1c0f3667d93a/etsy-6.jpg","https://media.gemworkers.com/items/65974e2c-1041-4c24-b0d6-1c0f3667d93a/etsy-7.jpg","https://media.gemworkers.com/items/65974e2c-1041-4c24-b0d6-1c0f3667d93a/etsy-8.jpg","https://media.gemworkers.com/items/65974e2c-1041-4c24-b0d6-1c0f3667d93a/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Emerald,Emerald supplies,Emerald rings,Emerald earrings,Oceangemsminerals,Gift for her,Natural stone,Jewellery making,Rings for women,Rings for men,Emerald Jewellery,Bicolour Emerald,Emerald Cabochons.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('4208e2c4-8626-4125-9b7c-d044ea113e35', '9.2 Cts Green Tourmaline Lot', 'Tourmaline lot  

strong colour, high lustre 

ethically sourced 

9.20 Cts
8 to 5mm

 No treatment whatsoever', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 161, 1, 'loose_stone', 'Tourmaline', NULL, 9.2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/4208e2c4-8626-4125-9b7c-d044ea113e35/etsy-1.jpg","https://media.gemworkers.com/items/4208e2c4-8626-4125-9b7c-d044ea113e35/etsy-2.jpg","https://media.gemworkers.com/items/4208e2c4-8626-4125-9b7c-d044ea113e35/etsy-3.jpg","https://media.gemworkers.com/items/4208e2c4-8626-4125-9b7c-d044ea113e35/etsy-4.jpg","https://media.gemworkers.com/items/4208e2c4-8626-4125-9b7c-d044ea113e35/etsy-5.jpg","https://media.gemworkers.com/items/4208e2c4-8626-4125-9b7c-d044ea113e35/etsy-6.jpg","https://media.gemworkers.com/items/4208e2c4-8626-4125-9b7c-d044ea113e35/etsy-7.jpg","https://media.gemworkers.com/items/4208e2c4-8626-4125-9b7c-d044ea113e35/etsy-8.jpg","https://media.gemworkers.com/items/4208e2c4-8626-4125-9b7c-d044ea113e35/etsy-9.jpg","https://media.gemworkers.com/items/4208e2c4-8626-4125-9b7c-d044ea113e35/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 180 USD, converted at ECB rate. Etsy tags: Tourmaline Earrings,Jewellery Making,Jewellery Findings,y2k earrings stud,Earrings findings,emerald cut,bicolour tourmaline,Tourmaline Pairs,gift for her,Natural Stone,blue tourmaline lot,Oceangemsminerals,Green Tourmaline. Had variations on Etsy — check size/options.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('c25fdf2f-0768-4fd8-a916-f6f763fa1948', '8.40 Cts, pink tourmaline lot', 'Elegant Afghan pink colour tourmaline 

High lustre, glowing and bright colour 

8.40 carats 
Dimension:6x5x4mm to 8x5.5x5mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 313, 1, 'loose_stone', 'Tourmaline', NULL, 8.4, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/c25fdf2f-0768-4fd8-a916-f6f763fa1948/etsy-1.jpg","https://media.gemworkers.com/items/c25fdf2f-0768-4fd8-a916-f6f763fa1948/etsy-2.jpg","https://media.gemworkers.com/items/c25fdf2f-0768-4fd8-a916-f6f763fa1948/etsy-3.jpg","https://media.gemworkers.com/items/c25fdf2f-0768-4fd8-a916-f6f763fa1948/etsy-4.jpg","https://media.gemworkers.com/items/c25fdf2f-0768-4fd8-a916-f6f763fa1948/etsy-5.jpg","https://media.gemworkers.com/items/c25fdf2f-0768-4fd8-a916-f6f763fa1948/etsy-6.jpg","https://media.gemworkers.com/items/c25fdf2f-0768-4fd8-a916-f6f763fa1948/etsy-7.jpg","https://media.gemworkers.com/items/c25fdf2f-0768-4fd8-a916-f6f763fa1948/etsy-8.jpg","https://media.gemworkers.com/items/c25fdf2f-0768-4fd8-a916-f6f763fa1948/etsy-9.jpg","https://media.gemworkers.com/items/c25fdf2f-0768-4fd8-a916-f6f763fa1948/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 350 USD, converted at ECB rate. Etsy tags: Jewellery Supplies,Jewellery Making,Rings For Men,Rings For Women,y2k earrings stud,Gift For Her,Tourmaline Jewellery,Natural Stone,Tourmaline Supplies,Jewellery Stud,pink tourmaline,Oceangemsminerals,orange tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('faf6a2b1-387b-4347-8b15-9ed432022b73', 'Tourmaline Lot Bicolour, Pink and White 3.30 Cts', 'A Mesmerising Tourmaline Lot, can be use for earrings and ring as a mismatched pairs

Very Cute Looking Tourmalines

Rare and quality stones.

Total weight: 3.30 Cts', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 134, 1, 'loose_stone', 'Tourmaline', NULL, 3.3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/faf6a2b1-387b-4347-8b15-9ed432022b73/etsy-1.jpg","https://media.gemworkers.com/items/faf6a2b1-387b-4347-8b15-9ed432022b73/etsy-2.jpg","https://media.gemworkers.com/items/faf6a2b1-387b-4347-8b15-9ed432022b73/etsy-3.jpg","https://media.gemworkers.com/items/faf6a2b1-387b-4347-8b15-9ed432022b73/etsy-4.jpg","https://media.gemworkers.com/items/faf6a2b1-387b-4347-8b15-9ed432022b73/etsy-5.jpg","https://media.gemworkers.com/items/faf6a2b1-387b-4347-8b15-9ed432022b73/etsy-6.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 150 USD, converted at ECB rate. Etsy tags: Emerald Cut,Bicolour Tourmaline,Watermelon Bicolour,Tourmaline Jewellery,Jewellery Supplies,Jewellery Making,Jewellery Findings,y2k earrings stud,Gift For Her,Gold Rings,Rings For Men,Rings For Women,Natural Stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('3980e4be-deda-4e5e-9854-f2184ed05258', '6.70 Cts Tourmaline Earrings Set', 'A Very High Lustre Unique Colour Tourmaline Set For Earrings 

High Quality Fine lustre

6.70 Cts
7 x 6 x 4.8mm
8.8 x 5.1 x 4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'jewelry', 'Tourmaline', NULL, 6.7, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/3980e4be-deda-4e5e-9854-f2184ed05258/etsy-1.jpg","https://media.gemworkers.com/items/3980e4be-deda-4e5e-9854-f2184ed05258/etsy-2.jpg","https://media.gemworkers.com/items/3980e4be-deda-4e5e-9854-f2184ed05258/etsy-3.jpg","https://media.gemworkers.com/items/3980e4be-deda-4e5e-9854-f2184ed05258/etsy-4.jpg","https://media.gemworkers.com/items/3980e4be-deda-4e5e-9854-f2184ed05258/etsy-5.jpg","https://media.gemworkers.com/items/3980e4be-deda-4e5e-9854-f2184ed05258/etsy-6.jpg","https://media.gemworkers.com/items/3980e4be-deda-4e5e-9854-f2184ed05258/etsy-7.jpg","https://media.gemworkers.com/items/3980e4be-deda-4e5e-9854-f2184ed05258/etsy-8.jpg","https://media.gemworkers.com/items/3980e4be-deda-4e5e-9854-f2184ed05258/etsy-9.jpg","https://media.gemworkers.com/items/3980e4be-deda-4e5e-9854-f2184ed05258/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Tourmaline Earrings,Earrings Set,Fine Tourmaline,Canary Tourmaline,Lagoon Tourmaline,Blue Tourmaline,Yellow Tourmaline,Stud Earrings,Tourmaline Jewellery,Jewellery Set,Oceangemsminerals,Tourmaline Pairs,Lagoon Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('1eb695a0-02dc-404f-9cb8-b1b7373f610d', '5.80 Cts Tourmaline Earrings Set', 'A Very High Lustre Unique Colour Tourmaline Set For Earrings 

High Quality Fine Cut

5.80 Cts
6.3 x 5.7 x 4.5mm
7.7 x 5.2 x 4.2mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'jewelry', 'Tourmaline', NULL, 5.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/1eb695a0-02dc-404f-9cb8-b1b7373f610d/etsy-1.jpg","https://media.gemworkers.com/items/1eb695a0-02dc-404f-9cb8-b1b7373f610d/etsy-2.jpg","https://media.gemworkers.com/items/1eb695a0-02dc-404f-9cb8-b1b7373f610d/etsy-3.jpg","https://media.gemworkers.com/items/1eb695a0-02dc-404f-9cb8-b1b7373f610d/etsy-4.jpg","https://media.gemworkers.com/items/1eb695a0-02dc-404f-9cb8-b1b7373f610d/etsy-5.jpg","https://media.gemworkers.com/items/1eb695a0-02dc-404f-9cb8-b1b7373f610d/etsy-6.jpg","https://media.gemworkers.com/items/1eb695a0-02dc-404f-9cb8-b1b7373f610d/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Tourmaline Earrings,Earrings Set,Fine Tourmaline,Canary Tourmaline,Lagoon Tourmaline,Blue Tourmaline,Yellow Tourmaline,Stud Earrings,Tourmaline Jewellery,Jewellery Set,Oceangemsminerals,Tourmaline Pairs,Lagoon Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('f48b05ea-0694-40b7-a768-b0d894fd100d', '6.95 Cts Unique Tourmaline Lot', 'Unique Tourmaline Lot

Gorgeous Looking Tourmaline.

One of a kind, 

6.95 carats 

Size:4.6mm to7.4mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 197, 1, 'loose_stone', 'Tourmaline', NULL, 6.95, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/f48b05ea-0694-40b7-a768-b0d894fd100d/etsy-1.jpg","https://media.gemworkers.com/items/f48b05ea-0694-40b7-a768-b0d894fd100d/etsy-2.jpg","https://media.gemworkers.com/items/f48b05ea-0694-40b7-a768-b0d894fd100d/etsy-3.jpg","https://media.gemworkers.com/items/f48b05ea-0694-40b7-a768-b0d894fd100d/etsy-4.jpg","https://media.gemworkers.com/items/f48b05ea-0694-40b7-a768-b0d894fd100d/etsy-5.jpg","https://media.gemworkers.com/items/f48b05ea-0694-40b7-a768-b0d894fd100d/etsy-6.jpg","https://media.gemworkers.com/items/f48b05ea-0694-40b7-a768-b0d894fd100d/etsy-7.jpg","https://media.gemworkers.com/items/f48b05ea-0694-40b7-a768-b0d894fd100d/etsy-8.jpg","https://media.gemworkers.com/items/f48b05ea-0694-40b7-a768-b0d894fd100d/etsy-9.jpg","https://media.gemworkers.com/items/f48b05ea-0694-40b7-a768-b0d894fd100d/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 220 USD, converted at ECB rate. Etsy tags: lagoon tourmaline,blue tourmaline,cushion cut,rings for women,rings for men,jewellery supplies,gift for her,rare tourmaline,jewellery making,jewellery findings,gold rings,y2k earrings,stud jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('57f10133-a579-4002-9779-d6a76ee0cb7d', '1.4Cts Ice Blue Tourmaline', 'Ice Blue Tourmaline 

Bright And Lustre

1.80 Cts
7.5 x 5.8 x 5.1mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 125, 1, 'loose_stone', 'Tourmaline', NULL, 1.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/57f10133-a579-4002-9779-d6a76ee0cb7d/etsy-1.jpg","https://media.gemworkers.com/items/57f10133-a579-4002-9779-d6a76ee0cb7d/etsy-2.jpg","https://media.gemworkers.com/items/57f10133-a579-4002-9779-d6a76ee0cb7d/etsy-3.jpg","https://media.gemworkers.com/items/57f10133-a579-4002-9779-d6a76ee0cb7d/etsy-4.jpg","https://media.gemworkers.com/items/57f10133-a579-4002-9779-d6a76ee0cb7d/etsy-5.jpg","https://media.gemworkers.com/items/57f10133-a579-4002-9779-d6a76ee0cb7d/etsy-6.jpg","https://media.gemworkers.com/items/57f10133-a579-4002-9779-d6a76ee0cb7d/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 140 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('ba5c27ae-d339-4193-b84c-5622360d718a', '3.75 Cts Paprok Bicolour Tourmaline.', 'Natural Paprok Bicolour Tourmaline 

More beautiful In real, One of a kind

3.75 Cts
16.5 x 5.3 x 4.6mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 250, 1, 'loose_stone', 'Tourmaline', NULL, 3.75, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/ba5c27ae-d339-4193-b84c-5622360d718a/etsy-1.jpg","https://media.gemworkers.com/items/ba5c27ae-d339-4193-b84c-5622360d718a/etsy-2.jpg","https://media.gemworkers.com/items/ba5c27ae-d339-4193-b84c-5622360d718a/etsy-3.jpg","https://media.gemworkers.com/items/ba5c27ae-d339-4193-b84c-5622360d718a/etsy-4.jpg","https://media.gemworkers.com/items/ba5c27ae-d339-4193-b84c-5622360d718a/etsy-5.jpg","https://media.gemworkers.com/items/ba5c27ae-d339-4193-b84c-5622360d718a/etsy-6.jpg","https://media.gemworkers.com/items/ba5c27ae-d339-4193-b84c-5622360d718a/etsy-7.jpg","https://media.gemworkers.com/items/ba5c27ae-d339-4193-b84c-5622360d718a/etsy-8.jpg","https://media.gemworkers.com/items/ba5c27ae-d339-4193-b84c-5622360d718a/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 280 USD, converted at ECB rate. Etsy tags: Jewellery Supplies,Jewellery Making,Gold Rings,Rings For Men,Rings For Women,y2k earrings stud,Gift For Her,Tourmaline Jewellery,Natural Stone,Stud Earrings,Jewellery Stud,bicolour Tourmaline,Lagoon tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('f40ebd6c-778a-4331-bf51-8c580d145712', '4.65 Cts Bicolour Tourmaline Pair.', 'To All The Bicolour Lovers Here Is An Incredible Opportunity Buy A Truly Exceptional And One Of A Kind Bicolour Tourmaline Pair at very reas price

4.65 Cts
10 x 6.5 x 3.8mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 4.65, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/f40ebd6c-778a-4331-bf51-8c580d145712/etsy-1.jpg","https://media.gemworkers.com/items/f40ebd6c-778a-4331-bf51-8c580d145712/etsy-2.jpg","https://media.gemworkers.com/items/f40ebd6c-778a-4331-bf51-8c580d145712/etsy-3.jpg","https://media.gemworkers.com/items/f40ebd6c-778a-4331-bf51-8c580d145712/etsy-4.jpg","https://media.gemworkers.com/items/f40ebd6c-778a-4331-bf51-8c580d145712/etsy-5.jpg","https://media.gemworkers.com/items/f40ebd6c-778a-4331-bf51-8c580d145712/etsy-6.jpg","https://media.gemworkers.com/items/f40ebd6c-778a-4331-bf51-8c580d145712/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,jewels,Handmadejewellery,gift for her,Topqualitytourmaline,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('c812b40e-44ac-4e64-a59f-ac5df96d5109', 'Lagoon and neon blue tourmaline 2.20 Cts', 'lagoon and neon blue colour tourmalines

top colour high lustre and brilliance 

2.20 Cts

6 x 5 x 3.5mm
6 x 4 x 3.5mm

100% natural no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 2.2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/c812b40e-44ac-4e64-a59f-ac5df96d5109/etsy-1.jpg","https://media.gemworkers.com/items/c812b40e-44ac-4e64-a59f-ac5df96d5109/etsy-2.jpg","https://media.gemworkers.com/items/c812b40e-44ac-4e64-a59f-ac5df96d5109/etsy-3.jpg","https://media.gemworkers.com/items/c812b40e-44ac-4e64-a59f-ac5df96d5109/etsy-4.jpg","https://media.gemworkers.com/items/c812b40e-44ac-4e64-a59f-ac5df96d5109/etsy-5.jpg","https://media.gemworkers.com/items/c812b40e-44ac-4e64-a59f-ac5df96d5109/etsy-6.jpg","https://media.gemworkers.com/items/c812b40e-44ac-4e64-a59f-ac5df96d5109/etsy-7.jpg","https://media.gemworkers.com/items/c812b40e-44ac-4e64-a59f-ac5df96d5109/etsy-8.jpg","https://media.gemworkers.com/items/c812b40e-44ac-4e64-a59f-ac5df96d5109/etsy-9.jpg","https://media.gemworkers.com/items/c812b40e-44ac-4e64-a59f-ac5df96d5109/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Natural Stone,Jewellery Supplies,Jewellery Making,Jewellery Findings,y2k stud earrings,Gift For Her,Rings For Men,Rings For Women,Gold Rings,Silver Sterling,Garnet Necklace,Garnet Rings,Garnet Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('9a61ab48-fb72-490d-a47a-d35df6eb63ec', '3.50 Cts Tourmaline Earrings Set', 'A Very High Lustre Unique Colour Tourmaline Set For Earrings 

High Quality Fine Cut

3.50 carats 

Size:5.1mm to 6.6mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'jewelry', 'Tourmaline', NULL, 3.5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/9a61ab48-fb72-490d-a47a-d35df6eb63ec/etsy-1.jpg","https://media.gemworkers.com/items/9a61ab48-fb72-490d-a47a-d35df6eb63ec/etsy-2.jpg","https://media.gemworkers.com/items/9a61ab48-fb72-490d-a47a-d35df6eb63ec/etsy-3.jpg","https://media.gemworkers.com/items/9a61ab48-fb72-490d-a47a-d35df6eb63ec/etsy-4.jpg","https://media.gemworkers.com/items/9a61ab48-fb72-490d-a47a-d35df6eb63ec/etsy-5.jpg","https://media.gemworkers.com/items/9a61ab48-fb72-490d-a47a-d35df6eb63ec/etsy-6.jpg","https://media.gemworkers.com/items/9a61ab48-fb72-490d-a47a-d35df6eb63ec/etsy-7.jpg","https://media.gemworkers.com/items/9a61ab48-fb72-490d-a47a-d35df6eb63ec/etsy-8.jpg","https://media.gemworkers.com/items/9a61ab48-fb72-490d-a47a-d35df6eb63ec/etsy-9.jpg","https://media.gemworkers.com/items/9a61ab48-fb72-490d-a47a-d35df6eb63ec/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Tourmaline Earrings,Earrings Set,Fine Tourmaline,Canary Tourmaline,Lagoon Tourmaline,Blue Tourmaline,Yellow Tourmaline,Stud Earrings,Tourmaline Jewellery,Jewellery Set,Oceangemsminerals,Tourmaline Pairs,Lagoon Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('875217e2-34ea-4049-ab78-ab50622bd07a', '3.90 Cts Emerald Lot', 'Gorgeous Emerald From Swat

Colour is more beautiful in real 

3.90 carats 

Size:3mm to 6.9mm

Unheated,', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Emerald', NULL, 3.9, 'ct', 'Pakistan', NULL, NULL, '["https://media.gemworkers.com/items/875217e2-34ea-4049-ab78-ab50622bd07a/etsy-1.jpg","https://media.gemworkers.com/items/875217e2-34ea-4049-ab78-ab50622bd07a/etsy-2.jpg","https://media.gemworkers.com/items/875217e2-34ea-4049-ab78-ab50622bd07a/etsy-3.jpg","https://media.gemworkers.com/items/875217e2-34ea-4049-ab78-ab50622bd07a/etsy-4.jpg","https://media.gemworkers.com/items/875217e2-34ea-4049-ab78-ab50622bd07a/etsy-5.jpg","https://media.gemworkers.com/items/875217e2-34ea-4049-ab78-ab50622bd07a/etsy-6.jpg","https://media.gemworkers.com/items/875217e2-34ea-4049-ab78-ab50622bd07a/etsy-7.jpg","https://media.gemworkers.com/items/875217e2-34ea-4049-ab78-ab50622bd07a/etsy-8.jpg","https://media.gemworkers.com/items/875217e2-34ea-4049-ab78-ab50622bd07a/etsy-9.jpg","https://media.gemworkers.com/items/875217e2-34ea-4049-ab78-ab50622bd07a/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Emerald,Emerald supplies,Emerald rings,Emerald earrings,Oceangemsminerals,Gift for her,Natural stone,Jewellery making,Rings for women,Rings for men,Lagoon tourmaline,Jewellers,Emerald Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('8d4425c9-e4d4-43f5-b1de-f6fad7bb84c1', 'Canary Green Mismatched Tourmaline Pair 2.40 Cts', 'Canary Green Colour Mesmerising Afghan Tourmaline Pair 

Included But High Lustre 

unique pair and rare find

Weight:2.40 carats 
Dimension: 6 x 5 x 4mm

no treatment', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 107, 1, 'loose_stone', 'Tourmaline', NULL, 2.4, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/8d4425c9-e4d4-43f5-b1de-f6fad7bb84c1/etsy-1.jpg","https://media.gemworkers.com/items/8d4425c9-e4d4-43f5-b1de-f6fad7bb84c1/etsy-2.jpg","https://media.gemworkers.com/items/8d4425c9-e4d4-43f5-b1de-f6fad7bb84c1/etsy-3.jpg","https://media.gemworkers.com/items/8d4425c9-e4d4-43f5-b1de-f6fad7bb84c1/etsy-4.jpg","https://media.gemworkers.com/items/8d4425c9-e4d4-43f5-b1de-f6fad7bb84c1/etsy-5.jpg","https://media.gemworkers.com/items/8d4425c9-e4d4-43f5-b1de-f6fad7bb84c1/etsy-6.jpg","https://media.gemworkers.com/items/8d4425c9-e4d4-43f5-b1de-f6fad7bb84c1/etsy-7.jpg","https://media.gemworkers.com/items/8d4425c9-e4d4-43f5-b1de-f6fad7bb84c1/etsy-8.jpg","https://media.gemworkers.com/items/8d4425c9-e4d4-43f5-b1de-f6fad7bb84c1/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 120 USD, converted at ECB rate. Etsy tags: Jewellery Making,Jewellery Supplies,Jewellery Findings,Tourmaline Jewellery,Tourmaline Earrings,Blue Tourmaline,Bicolour Tourmaline,Earrings Findings,y2k earrings stud,Stud earrings,Gift For Her,Natural Stone,Tourmaline Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('510fa28d-451a-4dd5-9536-cdd696ff94c9', '3.5 Cts, Mint Green Tourmaline', 'Mesmerising Mint Green Colour Afghan Tourmaline 

Ethically Sourced, Loupe Clean

Cut To Perfection 

high lustre and brilliance 

3.50 Cts
24 x 4.3 x 3.8mm

Unheated, No treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 357, 1, 'loose_stone', 'Tourmaline', NULL, 3.5, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/510fa28d-451a-4dd5-9536-cdd696ff94c9/etsy-1.jpg","https://media.gemworkers.com/items/510fa28d-451a-4dd5-9536-cdd696ff94c9/etsy-2.jpg","https://media.gemworkers.com/items/510fa28d-451a-4dd5-9536-cdd696ff94c9/etsy-3.jpg","https://media.gemworkers.com/items/510fa28d-451a-4dd5-9536-cdd696ff94c9/etsy-4.jpg","https://media.gemworkers.com/items/510fa28d-451a-4dd5-9536-cdd696ff94c9/etsy-5.jpg","https://media.gemworkers.com/items/510fa28d-451a-4dd5-9536-cdd696ff94c9/etsy-6.jpg","https://media.gemworkers.com/items/510fa28d-451a-4dd5-9536-cdd696ff94c9/etsy-7.jpg","https://media.gemworkers.com/items/510fa28d-451a-4dd5-9536-cdd696ff94c9/etsy-8.jpg","https://media.gemworkers.com/items/510fa28d-451a-4dd5-9536-cdd696ff94c9/etsy-9.jpg","https://media.gemworkers.com/items/510fa28d-451a-4dd5-9536-cdd696ff94c9/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 400 USD, converted at ECB rate. Etsy tags: Jewellery Making,Rings For Women,Jewellery Finding,Rings For Men,Jewels,Gold Rings,Jewellery Supplies,Gift For Her,Natural Stone,Blue tourmaline,lagoon Tourmaline,MintGreen Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('e16e4004-2288-4f48-bb71-d77a1cf24f51', '4 Cts, Deep Blue Tourmaline Pair', 'Gorgeous Deep Blue Mesmerising Afghan Tourmaline 

Unique And Rare 

4 Cts
13.5 x 4.4 x 3.8mm

glowing 

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 178, 1, 'loose_stone', 'Tourmaline', NULL, 4, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/e16e4004-2288-4f48-bb71-d77a1cf24f51/etsy-1.jpg","https://media.gemworkers.com/items/e16e4004-2288-4f48-bb71-d77a1cf24f51/etsy-2.jpg","https://media.gemworkers.com/items/e16e4004-2288-4f48-bb71-d77a1cf24f51/etsy-3.jpg","https://media.gemworkers.com/items/e16e4004-2288-4f48-bb71-d77a1cf24f51/etsy-4.jpg","https://media.gemworkers.com/items/e16e4004-2288-4f48-bb71-d77a1cf24f51/etsy-5.jpg","https://media.gemworkers.com/items/e16e4004-2288-4f48-bb71-d77a1cf24f51/etsy-6.jpg","https://media.gemworkers.com/items/e16e4004-2288-4f48-bb71-d77a1cf24f51/etsy-7.jpg","https://media.gemworkers.com/items/e16e4004-2288-4f48-bb71-d77a1cf24f51/etsy-8.jpg","https://media.gemworkers.com/items/e16e4004-2288-4f48-bb71-d77a1cf24f51/etsy-9.jpg","https://media.gemworkers.com/items/e16e4004-2288-4f48-bb71-d77a1cf24f51/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 199 USD, converted at ECB rate. Etsy tags: Bicolour Tourmaline,Blue Tourmaline,Lagoon Tourmaline,Neon Tourmaline,Tourmaline jewellery,gift for her,natural stone,Tourmaline Rings,tourmaline necklace,rings for men,rings for women,Oceangemsminerals,tourmaline pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('b5298a88-4978-494b-a128-a000f42d88cb', '4.8 Cts, Deep Blue Tourmaline Pair', 'Gorgeous Deep Blue Mesmerising Afghan Tourmaline 

Unique And Rare 

4.80 Cts
16 x 4.4 x 3.8mm

glowing 

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 4.8, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/b5298a88-4978-494b-a128-a000f42d88cb/etsy-1.jpg","https://media.gemworkers.com/items/b5298a88-4978-494b-a128-a000f42d88cb/etsy-2.jpg","https://media.gemworkers.com/items/b5298a88-4978-494b-a128-a000f42d88cb/etsy-3.jpg","https://media.gemworkers.com/items/b5298a88-4978-494b-a128-a000f42d88cb/etsy-4.jpg","https://media.gemworkers.com/items/b5298a88-4978-494b-a128-a000f42d88cb/etsy-5.jpg","https://media.gemworkers.com/items/b5298a88-4978-494b-a128-a000f42d88cb/etsy-6.jpg","https://media.gemworkers.com/items/b5298a88-4978-494b-a128-a000f42d88cb/etsy-7.jpg","https://media.gemworkers.com/items/b5298a88-4978-494b-a128-a000f42d88cb/etsy-8.jpg","https://media.gemworkers.com/items/b5298a88-4978-494b-a128-a000f42d88cb/etsy-9.jpg","https://media.gemworkers.com/items/b5298a88-4978-494b-a128-a000f42d88cb/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Bicolour Tourmaline,Blue Tourmaline,Lagoon Tourmaline,Neon Tourmaline,Tourmaline jewellery,gift for her,natural stone,Tourmaline Rings,tourmaline necklace,rings for men,rings for women,Oceangemsminerals,tourmaline pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('29c658ee-933e-441f-9cd4-5af8ca71d42e', '1.45 Cts Lagoon Seafoam Colour Tourmaline', 'Top Quality Lagoon Seafoam Colour Tourmaline Cushion Cut

rare find

1.45 carats 

Size:6x6x5mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 1.45, 'ct', NULL, NULL, '6x6x5', '["https://media.gemworkers.com/items/29c658ee-933e-441f-9cd4-5af8ca71d42e/etsy-1.jpg","https://media.gemworkers.com/items/29c658ee-933e-441f-9cd4-5af8ca71d42e/etsy-2.jpg","https://media.gemworkers.com/items/29c658ee-933e-441f-9cd4-5af8ca71d42e/etsy-3.jpg","https://media.gemworkers.com/items/29c658ee-933e-441f-9cd4-5af8ca71d42e/etsy-4.jpg","https://media.gemworkers.com/items/29c658ee-933e-441f-9cd4-5af8ca71d42e/etsy-5.jpg","https://media.gemworkers.com/items/29c658ee-933e-441f-9cd4-5af8ca71d42e/etsy-6.jpg","https://media.gemworkers.com/items/29c658ee-933e-441f-9cd4-5af8ca71d42e/etsy-7.jpg","https://media.gemworkers.com/items/29c658ee-933e-441f-9cd4-5af8ca71d42e/etsy-8.jpg","https://media.gemworkers.com/items/29c658ee-933e-441f-9cd4-5af8ca71d42e/etsy-9.jpg","https://media.gemworkers.com/items/29c658ee-933e-441f-9cd4-5af8ca71d42e/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('cb9dded4-9f95-40be-9ac2-6166797c9bb8', '2.80 Cts Baby Pink Tourmaline', 'Gorgeous trillion cut Rubilite Tourmalines

2.80 Cts
9.4 x 9.4 x 4.3mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 178, 1, 'loose_stone', 'Tourmaline', NULL, 2.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/cb9dded4-9f95-40be-9ac2-6166797c9bb8/etsy-1.jpg","https://media.gemworkers.com/items/cb9dded4-9f95-40be-9ac2-6166797c9bb8/etsy-2.jpg","https://media.gemworkers.com/items/cb9dded4-9f95-40be-9ac2-6166797c9bb8/etsy-3.jpg","https://media.gemworkers.com/items/cb9dded4-9f95-40be-9ac2-6166797c9bb8/etsy-4.jpg","https://media.gemworkers.com/items/cb9dded4-9f95-40be-9ac2-6166797c9bb8/etsy-5.jpg","https://media.gemworkers.com/items/cb9dded4-9f95-40be-9ac2-6166797c9bb8/etsy-6.jpg","https://media.gemworkers.com/items/cb9dded4-9f95-40be-9ac2-6166797c9bb8/etsy-7.jpg","https://media.gemworkers.com/items/cb9dded4-9f95-40be-9ac2-6166797c9bb8/etsy-8.jpg","https://media.gemworkers.com/items/cb9dded4-9f95-40be-9ac2-6166797c9bb8/etsy-9.jpg","https://media.gemworkers.com/items/cb9dded4-9f95-40be-9ac2-6166797c9bb8/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 199 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('be22287d-c79f-4f11-a7de-6df5c35c57fd', '14.20 Cts, Indicolite Saphire Blue Colour Tourmaline.', 'Gorgeous Mesmerising Saphire Blue Colour Afghan Tourmaline,

Unique Colour, 

Cut to perfection, Top Polished. 

Such Stones Are Very Few In Our Market And It’s High Demanded So We Brought This In One In Most Reasonable Price.

14.20 carats 
Dimension:15.5x11x8mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 1071, 1, 'loose_stone', 'Tourmaline', 'Indicolite', 14.2, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/be22287d-c79f-4f11-a7de-6df5c35c57fd/etsy-1.jpg","https://media.gemworkers.com/items/be22287d-c79f-4f11-a7de-6df5c35c57fd/etsy-2.jpg","https://media.gemworkers.com/items/be22287d-c79f-4f11-a7de-6df5c35c57fd/etsy-3.jpg","https://media.gemworkers.com/items/be22287d-c79f-4f11-a7de-6df5c35c57fd/etsy-4.jpg","https://media.gemworkers.com/items/be22287d-c79f-4f11-a7de-6df5c35c57fd/etsy-5.jpg","https://media.gemworkers.com/items/be22287d-c79f-4f11-a7de-6df5c35c57fd/etsy-6.jpg","https://media.gemworkers.com/items/be22287d-c79f-4f11-a7de-6df5c35c57fd/etsy-7.jpg","https://media.gemworkers.com/items/be22287d-c79f-4f11-a7de-6df5c35c57fd/etsy-8.jpg","https://media.gemworkers.com/items/be22287d-c79f-4f11-a7de-6df5c35c57fd/etsy-9.jpg","https://media.gemworkers.com/items/be22287d-c79f-4f11-a7de-6df5c35c57fd/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 1199 USD, converted at ECB rate. Etsy tags: Blue Tourmaline,Lagoon Tourmaline,Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery findings,gift for her,natural stone,Oceangemsminerals,Sky Blue Tourmaline,Neon Blue Tourmaline,Ink Blue Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('6d5aa517-fdee-4670-9c8a-7111b15e59f6', '7.50 Cts, Natural Bicolour Afghan Tourmalines', 'Gorgeous Mesmerising Natural Bicolour Afghan Tourmalines

high lustre, Saturated Colour.

Weight:7.50 carats 
Dimension:12x5x4mm to 19x4.9x3.9mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 7.5, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/6d5aa517-fdee-4670-9c8a-7111b15e59f6/etsy-1.jpg","https://media.gemworkers.com/items/6d5aa517-fdee-4670-9c8a-7111b15e59f6/etsy-2.jpg","https://media.gemworkers.com/items/6d5aa517-fdee-4670-9c8a-7111b15e59f6/etsy-3.jpg","https://media.gemworkers.com/items/6d5aa517-fdee-4670-9c8a-7111b15e59f6/etsy-4.jpg","https://media.gemworkers.com/items/6d5aa517-fdee-4670-9c8a-7111b15e59f6/etsy-5.jpg","https://media.gemworkers.com/items/6d5aa517-fdee-4670-9c8a-7111b15e59f6/etsy-6.jpg","https://media.gemworkers.com/items/6d5aa517-fdee-4670-9c8a-7111b15e59f6/etsy-7.jpg","https://media.gemworkers.com/items/6d5aa517-fdee-4670-9c8a-7111b15e59f6/etsy-8.jpg","https://media.gemworkers.com/items/6d5aa517-fdee-4670-9c8a-7111b15e59f6/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery findings,gift for her,natural stone,Oceangemsminerals,apple green colour,Bicolour Tourmaline,Natural Bicolour,Unheated Tourmaline,Lipstick Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('7224b71e-251a-49f2-a8de-f8a8c829dd4c', '3.30 Cts, Blue Green Tourmaline', 'Gorgeous Mesmerising Blue Green Afghan Tourmaline 

Unique Colour 

3.30 carats 
8.6 x 7.9 x 6.6mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 3.3, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/7224b71e-251a-49f2-a8de-f8a8c829dd4c/etsy-1.jpg","https://media.gemworkers.com/items/7224b71e-251a-49f2-a8de-f8a8c829dd4c/etsy-2.jpg","https://media.gemworkers.com/items/7224b71e-251a-49f2-a8de-f8a8c829dd4c/etsy-3.jpg","https://media.gemworkers.com/items/7224b71e-251a-49f2-a8de-f8a8c829dd4c/etsy-4.jpg","https://media.gemworkers.com/items/7224b71e-251a-49f2-a8de-f8a8c829dd4c/etsy-5.jpg","https://media.gemworkers.com/items/7224b71e-251a-49f2-a8de-f8a8c829dd4c/etsy-6.jpg","https://media.gemworkers.com/items/7224b71e-251a-49f2-a8de-f8a8c829dd4c/etsy-7.jpg","https://media.gemworkers.com/items/7224b71e-251a-49f2-a8de-f8a8c829dd4c/etsy-8.jpg","https://media.gemworkers.com/items/7224b71e-251a-49f2-a8de-f8a8c829dd4c/etsy-9.jpg","https://media.gemworkers.com/items/7224b71e-251a-49f2-a8de-f8a8c829dd4c/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: BlueGreen Tourmaline,Blue Tourmaline,Green Tourmaline,Lagoon Tourmaline,Neon Tourmaline,Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery supplies,jewellery findings,gift for her,natural stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('af494bb0-ca72-409c-9e29-9f40be649786', '7 Cts Tourmaline Lot', 'Gorgeous Tourmaline Lot 

 good lustre

7 Cts
14.5 to 15.5mm

100% Natural No treatment whatsoever', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 125, 1, 'loose_stone', 'Tourmaline', NULL, 7, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/af494bb0-ca72-409c-9e29-9f40be649786/etsy-1.jpg","https://media.gemworkers.com/items/af494bb0-ca72-409c-9e29-9f40be649786/etsy-2.jpg","https://media.gemworkers.com/items/af494bb0-ca72-409c-9e29-9f40be649786/etsy-3.jpg","https://media.gemworkers.com/items/af494bb0-ca72-409c-9e29-9f40be649786/etsy-4.jpg","https://media.gemworkers.com/items/af494bb0-ca72-409c-9e29-9f40be649786/etsy-5.jpg","https://media.gemworkers.com/items/af494bb0-ca72-409c-9e29-9f40be649786/etsy-6.jpg","https://media.gemworkers.com/items/af494bb0-ca72-409c-9e29-9f40be649786/etsy-7.jpg","https://media.gemworkers.com/items/af494bb0-ca72-409c-9e29-9f40be649786/etsy-8.jpg","https://media.gemworkers.com/items/af494bb0-ca72-409c-9e29-9f40be649786/etsy-9.jpg","https://media.gemworkers.com/items/af494bb0-ca72-409c-9e29-9f40be649786/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 140 USD, converted at ECB rate. Etsy tags: Tourmaline Earrings,Jewellery Making,Jewellery Findings,y2k earrings stud,Earrings findings,emerald cut,bicolour tourmaline,Tourmaline Pairs,gift for her,Natural Stone,blue tourmaline lot,Oceangemsminerals,Clean Tourmaline. Had variations on Etsy — check size/options.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('7c9f2655-1146-4a00-8e9b-f6d42d9cfa0c', '10.70 Cts, Bicolour Tourmaline Lot.', 'Pink And Neon Blue Colour Bicolour Afghan Tourmaline Lot

Exceptional

10.70 Cts
3.6 to 6.8mm

no treatment whatsoever', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 10.7, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/7c9f2655-1146-4a00-8e9b-f6d42d9cfa0c/etsy-1.jpg","https://media.gemworkers.com/items/7c9f2655-1146-4a00-8e9b-f6d42d9cfa0c/etsy-2.jpg","https://media.gemworkers.com/items/7c9f2655-1146-4a00-8e9b-f6d42d9cfa0c/etsy-3.jpg","https://media.gemworkers.com/items/7c9f2655-1146-4a00-8e9b-f6d42d9cfa0c/etsy-4.jpg","https://media.gemworkers.com/items/7c9f2655-1146-4a00-8e9b-f6d42d9cfa0c/etsy-5.jpg","https://media.gemworkers.com/items/7c9f2655-1146-4a00-8e9b-f6d42d9cfa0c/etsy-6.jpg","https://media.gemworkers.com/items/7c9f2655-1146-4a00-8e9b-f6d42d9cfa0c/etsy-7.jpg","https://media.gemworkers.com/items/7c9f2655-1146-4a00-8e9b-f6d42d9cfa0c/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Rings,Natural Stone,Bicolour Tourmaline,Loose gemstones,Gold Rings,Rings For women,Rings For Men,y2k earrings stud,Oceangemsminerals,Lagoon Tourmaline,Blue Tourmaline,Pink Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('69a081bc-0ce5-46ae-8fbe-fc71475f7301', '10.40 Cts, Bicolour Tourmaline Lot.', 'Pink And Neon Blue Colour Bicolour Afghan Tourmaline Lot

Exceptional

10.40 Cts
4 to 6mm

no treatment whatsoever', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 250, 1, 'loose_stone', 'Tourmaline', NULL, 10.4, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/69a081bc-0ce5-46ae-8fbe-fc71475f7301/etsy-1.jpg","https://media.gemworkers.com/items/69a081bc-0ce5-46ae-8fbe-fc71475f7301/etsy-2.jpg","https://media.gemworkers.com/items/69a081bc-0ce5-46ae-8fbe-fc71475f7301/etsy-3.jpg","https://media.gemworkers.com/items/69a081bc-0ce5-46ae-8fbe-fc71475f7301/etsy-4.jpg","https://media.gemworkers.com/items/69a081bc-0ce5-46ae-8fbe-fc71475f7301/etsy-5.jpg","https://media.gemworkers.com/items/69a081bc-0ce5-46ae-8fbe-fc71475f7301/etsy-6.jpg","https://media.gemworkers.com/items/69a081bc-0ce5-46ae-8fbe-fc71475f7301/etsy-7.jpg","https://media.gemworkers.com/items/69a081bc-0ce5-46ae-8fbe-fc71475f7301/etsy-8.jpg","https://media.gemworkers.com/items/69a081bc-0ce5-46ae-8fbe-fc71475f7301/etsy-9.jpg","https://media.gemworkers.com/items/69a081bc-0ce5-46ae-8fbe-fc71475f7301/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 280 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Rings,Natural Stone,Bicolour Tourmaline,Loose gemstones,Gold Rings,Rings For women,Rings For Men,y2k earrings stud,Oceangemsminerals,Lagoon Tourmaline,Blue Tourmaline,Pink Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('a5c216a1-e303-4a69-9b90-5fc712795999', 'Green Tourmaline 1.90 Cts', 'Green Tourmaline 

unique colour 

1.90 carats 
7.7 x 6.3 x 5mm

no treatment', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 89, 1, 'loose_stone', 'Tourmaline', NULL, 1.9, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/a5c216a1-e303-4a69-9b90-5fc712795999/etsy-1.jpg","https://media.gemworkers.com/items/a5c216a1-e303-4a69-9b90-5fc712795999/etsy-2.jpg","https://media.gemworkers.com/items/a5c216a1-e303-4a69-9b90-5fc712795999/etsy-3.jpg","https://media.gemworkers.com/items/a5c216a1-e303-4a69-9b90-5fc712795999/etsy-4.jpg","https://media.gemworkers.com/items/a5c216a1-e303-4a69-9b90-5fc712795999/etsy-5.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 100 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Jewellery Making,Jewellery supplies,jewellery findings,Gold Rings,Rings For Women,Natural Stone,Handmade,Gift For Her,Green Tourmaline,Cushion Cut,Tourmaline Rings,Rings Supplies.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('eded0491-8db7-4c4a-8df8-d0a71b532fe3', 'Seafoam Green Tourmaline Lot 8.90 Cts', 'Mesmerising Seafoam Green Tourmaline Lot

8.90 Cts
16 x 3.5 x 2.5mm
8.5 x 3 x 3mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 8.9, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/eded0491-8db7-4c4a-8df8-d0a71b532fe3/etsy-1.jpg","https://media.gemworkers.com/items/eded0491-8db7-4c4a-8df8-d0a71b532fe3/etsy-2.jpg","https://media.gemworkers.com/items/eded0491-8db7-4c4a-8df8-d0a71b532fe3/etsy-3.jpg","https://media.gemworkers.com/items/eded0491-8db7-4c4a-8df8-d0a71b532fe3/etsy-4.jpg","https://media.gemworkers.com/items/eded0491-8db7-4c4a-8df8-d0a71b532fe3/etsy-5.jpg","https://media.gemworkers.com/items/eded0491-8db7-4c4a-8df8-d0a71b532fe3/etsy-6.jpg","https://media.gemworkers.com/items/eded0491-8db7-4c4a-8df8-d0a71b532fe3/etsy-7.jpg","https://media.gemworkers.com/items/eded0491-8db7-4c4a-8df8-d0a71b532fe3/etsy-8.jpg","https://media.gemworkers.com/items/eded0491-8db7-4c4a-8df8-d0a71b532fe3/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Seafoam Tourmaline,Emerald Cut,Tourmaline Lot,Green Tourmaline,Loose Gemstones,Jewellery Making,Jewellery Supplies,jewellery findings,natural stone,jewels,Handmadejewellery,Lagoon Tourmaline,Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('b5e776ba-529c-4dcb-998b-7f4f4f97a715', 'Blue Bicolour Tourmaline, 4.90 Cts', 'Bicolour Blue Mesmerising Afghan Tourmaline 

4.90 Cts
13 x 6.5 x 5mm

glowing 

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 143, 1, 'loose_stone', 'Tourmaline', NULL, 4.9, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/b5e776ba-529c-4dcb-998b-7f4f4f97a715/etsy-1.jpg","https://media.gemworkers.com/items/b5e776ba-529c-4dcb-998b-7f4f4f97a715/etsy-2.jpg","https://media.gemworkers.com/items/b5e776ba-529c-4dcb-998b-7f4f4f97a715/etsy-3.jpg","https://media.gemworkers.com/items/b5e776ba-529c-4dcb-998b-7f4f4f97a715/etsy-4.jpg","https://media.gemworkers.com/items/b5e776ba-529c-4dcb-998b-7f4f4f97a715/etsy-5.jpg","https://media.gemworkers.com/items/b5e776ba-529c-4dcb-998b-7f4f4f97a715/etsy-6.jpg","https://media.gemworkers.com/items/b5e776ba-529c-4dcb-998b-7f4f4f97a715/etsy-7.jpg","https://media.gemworkers.com/items/b5e776ba-529c-4dcb-998b-7f4f4f97a715/etsy-8.jpg","https://media.gemworkers.com/items/b5e776ba-529c-4dcb-998b-7f4f4f97a715/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 160 USD, converted at ECB rate. Etsy tags: Bicolour Tourmaline,Blue Tourmaline,Lagoon Tourmaline,Neon Tourmaline,Tourmaline jewellery,gift for her,natural stone,Tourmaline Rings,tourmaline necklace,rings for men,rings for women,jewellery making,jewellery supplies.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('ce8f4028-7c8b-4e07-9898-d94b711c8fad', 'Peach Pink Bicolour Tourmaline, 3.60 Cts', 'Peach Pink Tourmaline With Golden colour 

gorgeous colour 

3.60 Cts
9.2 x 7.5 x 6.1mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 107, 1, 'loose_stone', 'Tourmaline', NULL, 3.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/ce8f4028-7c8b-4e07-9898-d94b711c8fad/etsy-1.jpg","https://media.gemworkers.com/items/ce8f4028-7c8b-4e07-9898-d94b711c8fad/etsy-2.jpg","https://media.gemworkers.com/items/ce8f4028-7c8b-4e07-9898-d94b711c8fad/etsy-3.jpg","https://media.gemworkers.com/items/ce8f4028-7c8b-4e07-9898-d94b711c8fad/etsy-4.jpg","https://media.gemworkers.com/items/ce8f4028-7c8b-4e07-9898-d94b711c8fad/etsy-5.jpg","https://media.gemworkers.com/items/ce8f4028-7c8b-4e07-9898-d94b711c8fad/etsy-6.jpg","https://media.gemworkers.com/items/ce8f4028-7c8b-4e07-9898-d94b711c8fad/etsy-7.jpg","https://media.gemworkers.com/items/ce8f4028-7c8b-4e07-9898-d94b711c8fad/etsy-8.jpg","https://media.gemworkers.com/items/ce8f4028-7c8b-4e07-9898-d94b711c8fad/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 120 USD, converted at ECB rate. Etsy tags: rings for women,loose gemstones,natural stone,gold rings,gift for her,jewellery making,jewellery supplies,jewels,Handmadejewellery,jewellery findings,Pink Bicolour,pink tourmaline,bicolour tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('b1512d7e-63c3-4a00-a3af-17d3cd981b71', 'Bicolour and mint green tourmalines 4.10 Cts', 'Bicolour Tourmaline And Top Mint Green Colour Tourmalines

4.10 Cts

biggest and smallest piece dimension below 
9 x 5 x 3.5mm
6.5 x 4 x 3mm

no treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 143, 1, 'loose_stone', 'Tourmaline', NULL, 4.1, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/b1512d7e-63c3-4a00-a3af-17d3cd981b71/etsy-1.jpg","https://media.gemworkers.com/items/b1512d7e-63c3-4a00-a3af-17d3cd981b71/etsy-2.jpg","https://media.gemworkers.com/items/b1512d7e-63c3-4a00-a3af-17d3cd981b71/etsy-3.jpg","https://media.gemworkers.com/items/b1512d7e-63c3-4a00-a3af-17d3cd981b71/etsy-4.jpg","https://media.gemworkers.com/items/b1512d7e-63c3-4a00-a3af-17d3cd981b71/etsy-5.jpg","https://media.gemworkers.com/items/b1512d7e-63c3-4a00-a3af-17d3cd981b71/etsy-6.jpg","https://media.gemworkers.com/items/b1512d7e-63c3-4a00-a3af-17d3cd981b71/etsy-7.jpg","https://media.gemworkers.com/items/b1512d7e-63c3-4a00-a3af-17d3cd981b71/etsy-8.jpg","https://media.gemworkers.com/items/b1512d7e-63c3-4a00-a3af-17d3cd981b71/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 160 USD, converted at ECB rate. Etsy tags: jewellery,tourmaline pair,earrings,tourmaline jewellery,bicolour tourmaline,Gift For Her,Jewellery making,jewellery supplies,jewellery findings,natural stone,rings for men,stud jewellery,rings for women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('aadbfa8a-7cd0-4dea-928e-94f48b434756', 'Bicolour Tourmaline 1.90 Cts', 'Natural bicolour mesmerising tourmaline 

Weight:1.90 carats 
Dimension:9.5x5x4mm

unheated,', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 89, 1, 'loose_stone', 'Tourmaline', NULL, 1.9, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/aadbfa8a-7cd0-4dea-928e-94f48b434756/etsy-1.jpg","https://media.gemworkers.com/items/aadbfa8a-7cd0-4dea-928e-94f48b434756/etsy-2.jpg","https://media.gemworkers.com/items/aadbfa8a-7cd0-4dea-928e-94f48b434756/etsy-3.jpg","https://media.gemworkers.com/items/aadbfa8a-7cd0-4dea-928e-94f48b434756/etsy-4.jpg","https://media.gemworkers.com/items/aadbfa8a-7cd0-4dea-928e-94f48b434756/etsy-5.jpg","https://media.gemworkers.com/items/aadbfa8a-7cd0-4dea-928e-94f48b434756/etsy-6.jpg","https://media.gemworkers.com/items/aadbfa8a-7cd0-4dea-928e-94f48b434756/etsy-7.jpg","https://media.gemworkers.com/items/aadbfa8a-7cd0-4dea-928e-94f48b434756/etsy-8.jpg","https://media.gemworkers.com/items/aadbfa8a-7cd0-4dea-928e-94f48b434756/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 100 USD, converted at ECB rate. Etsy tags: Rings for women,rings for men,natural stone,gift for her,jewellery making,jewellery supplies,jewellery findings,bicolour tourmaline,pink tourmaline,stud jewellery,tourmaline emerald,emerald cut,green tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('a928cc13-608d-45dc-8980-2abe29eca602', 'Seafoam And Pink Colour Tourmaline Lot 13 Cts', 'Beautiful Tourmaline Lot 

Bicolour, Seafoam,Green and pink colours 

Weight:13carat 
Size:5mm to 13mm long

no treatment whatsoever', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 344, 1, 'loose_stone', 'Tourmaline', NULL, 13, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/a928cc13-608d-45dc-8980-2abe29eca602/etsy-1.jpg","https://media.gemworkers.com/items/a928cc13-608d-45dc-8980-2abe29eca602/etsy-2.jpg","https://media.gemworkers.com/items/a928cc13-608d-45dc-8980-2abe29eca602/etsy-3.jpg","https://media.gemworkers.com/items/a928cc13-608d-45dc-8980-2abe29eca602/etsy-4.jpg","https://media.gemworkers.com/items/a928cc13-608d-45dc-8980-2abe29eca602/etsy-5.jpg","https://media.gemworkers.com/items/a928cc13-608d-45dc-8980-2abe29eca602/etsy-6.jpg","https://media.gemworkers.com/items/a928cc13-608d-45dc-8980-2abe29eca602/etsy-7.jpg","https://media.gemworkers.com/items/a928cc13-608d-45dc-8980-2abe29eca602/etsy-8.jpg","https://media.gemworkers.com/items/a928cc13-608d-45dc-8980-2abe29eca602/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 385 USD, converted at ECB rate. Etsy tags: Jewellery Making,Jewellery Supplies,Jewellery Findings,Tourmaline Lot,Seafoam Tourmaline,Green Tourmaline,Tourmaline Jewellery,Gift For Her,Natural Stone,Pink Tourmaline,Stud Earrings,Hoop earrings,handmade.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('52c7f18b-9940-4842-866a-545d3b63e516', '4 Carat Natural Bicolor Tourmaline Gemstone - Afghanistan', 'Weight:4 carats 
Dimension:8*7.5*6.5mm
Shipping worldwide 
No treatment 
Natural from afghanistan', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 125, 1, 'loose_stone', 'Tourmaline', NULL, 4, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/52c7f18b-9940-4842-866a-545d3b63e516/etsy-1.jpg","https://media.gemworkers.com/items/52c7f18b-9940-4842-866a-545d3b63e516/etsy-2.jpg","https://media.gemworkers.com/items/52c7f18b-9940-4842-866a-545d3b63e516/etsy-3.jpg","https://media.gemworkers.com/items/52c7f18b-9940-4842-866a-545d3b63e516/etsy-4.jpg","https://media.gemworkers.com/items/52c7f18b-9940-4842-866a-545d3b63e516/etsy-5.jpg","https://media.gemworkers.com/items/52c7f18b-9940-4842-866a-545d3b63e516/etsy-6.jpg","https://media.gemworkers.com/items/52c7f18b-9940-4842-866a-545d3b63e516/etsy-7.jpg","https://media.gemworkers.com/items/52c7f18b-9940-4842-866a-545d3b63e516/etsy-8.jpg","https://media.gemworkers.com/items/52c7f18b-9940-4842-866a-545d3b63e516/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 140 USD, converted at ECB rate. Etsy tags: amethyst,tourmaline rosecut,rosecuts,tourmaline crystal,tourmaline crystals,tourmaline,garnet,gemstones,crystal,aquamarine,kynite,afghanite,quartz.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('b333de10-d71d-4355-957a-6b204538ee6a', '5.90 Cts, Tourmaline Lot With Pairs,', 'A Tourmaline Lot with reverse Pairs

strong colour, high lustre 

5.90 carats 
4mm to 11mm

100% Natural No treatment whatsoever', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 161, 1, 'loose_stone', 'Tourmaline', NULL, 5.9, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/b333de10-d71d-4355-957a-6b204538ee6a/etsy-1.jpg","https://media.gemworkers.com/items/b333de10-d71d-4355-957a-6b204538ee6a/etsy-2.jpg","https://media.gemworkers.com/items/b333de10-d71d-4355-957a-6b204538ee6a/etsy-3.jpg","https://media.gemworkers.com/items/b333de10-d71d-4355-957a-6b204538ee6a/etsy-4.jpg","https://media.gemworkers.com/items/b333de10-d71d-4355-957a-6b204538ee6a/etsy-5.jpg","https://media.gemworkers.com/items/b333de10-d71d-4355-957a-6b204538ee6a/etsy-6.jpg","https://media.gemworkers.com/items/b333de10-d71d-4355-957a-6b204538ee6a/etsy-7.jpg","https://media.gemworkers.com/items/b333de10-d71d-4355-957a-6b204538ee6a/etsy-8.jpg","https://media.gemworkers.com/items/b333de10-d71d-4355-957a-6b204538ee6a/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 180 USD, converted at ECB rate. Etsy tags: Tourmaline Earrings,Jewellery Making,Jewellery Findings,y2k earrings stud,Earrings findings,emerald cut,bicolour tourmaline,Tourmaline Pairs,gift for her,Natural Stone,stud earrings,blue tourmaline lot,Oceangemsminerals. Had variations on Etsy — check size/options.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('f655f44b-51d1-4359-ab56-29ac544a9d9d', 'Olive Tourmaline, 1.40 Cts', 'Cool Olive Green Colour Tourmaline 

1.40 Cts
6.5 x 6.4 x 4.9mm

no treatment, unheated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 85, 1, 'loose_stone', 'Tourmaline', NULL, 1.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/f655f44b-51d1-4359-ab56-29ac544a9d9d/etsy-1.jpg","https://media.gemworkers.com/items/f655f44b-51d1-4359-ab56-29ac544a9d9d/etsy-2.jpg","https://media.gemworkers.com/items/f655f44b-51d1-4359-ab56-29ac544a9d9d/etsy-3.jpg","https://media.gemworkers.com/items/f655f44b-51d1-4359-ab56-29ac544a9d9d/etsy-4.jpg","https://media.gemworkers.com/items/f655f44b-51d1-4359-ab56-29ac544a9d9d/etsy-5.jpg","https://media.gemworkers.com/items/f655f44b-51d1-4359-ab56-29ac544a9d9d/etsy-6.jpg","https://media.gemworkers.com/items/f655f44b-51d1-4359-ab56-29ac544a9d9d/etsy-7.jpg","https://media.gemworkers.com/items/f655f44b-51d1-4359-ab56-29ac544a9d9d/etsy-8.jpg","https://media.gemworkers.com/items/f655f44b-51d1-4359-ab56-29ac544a9d9d/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 95 USD, converted at ECB rate. Etsy tags: Jewellery Making,Jewellery Supplies,Jewellery Findings,Earrings Findings,y2k earrings Stud,Stud jewellery,Natural Stone,Blue Tourmaline Pair,Gift For Her,Unique Pair,olive tourmaline,green tourmaline,olive green.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('3ea16b3a-1128-4ec9-a697-19382d47805a', '7.60 Cts Tourmaline Lot', 'Tourmaline lot  

strong colour, high lustre 

ethically sourced 

7.60 Cts
9.2 to 6mm

 No treatment whatsoever', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 134, 1, 'loose_stone', 'Tourmaline', NULL, 7.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/3ea16b3a-1128-4ec9-a697-19382d47805a/etsy-1.jpg","https://media.gemworkers.com/items/3ea16b3a-1128-4ec9-a697-19382d47805a/etsy-2.jpg","https://media.gemworkers.com/items/3ea16b3a-1128-4ec9-a697-19382d47805a/etsy-3.jpg","https://media.gemworkers.com/items/3ea16b3a-1128-4ec9-a697-19382d47805a/etsy-4.jpg","https://media.gemworkers.com/items/3ea16b3a-1128-4ec9-a697-19382d47805a/etsy-5.jpg","https://media.gemworkers.com/items/3ea16b3a-1128-4ec9-a697-19382d47805a/etsy-6.jpg","https://media.gemworkers.com/items/3ea16b3a-1128-4ec9-a697-19382d47805a/etsy-7.jpg","https://media.gemworkers.com/items/3ea16b3a-1128-4ec9-a697-19382d47805a/etsy-8.jpg","https://media.gemworkers.com/items/3ea16b3a-1128-4ec9-a697-19382d47805a/etsy-9.jpg","https://media.gemworkers.com/items/3ea16b3a-1128-4ec9-a697-19382d47805a/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 150 USD, converted at ECB rate. Etsy tags: Tourmaline Earrings,Jewellery Making,Jewellery Findings,y2k earrings stud,Earrings findings,emerald cut,bicolour tourmaline,Tourmaline Pairs,gift for her,Natural Stone,blue tourmaline lot,Oceangemsminerals,Green Tourmaline. Had variations on Etsy — check size/options.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('7efe0b2c-1331-47fa-acef-836389d8ffcd', '39.15 Cts Aquamarine Cabochon', 'big size Aquamarine Cabochon 

ethically sourced 

39.15 Cts
16.3 x 15.4 x 9.4mm
18.7 x 16 x 8.4mm

unheated, untreated m.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 107, 1, 'loose_stone', 'Aquamarine', NULL, 39.15, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/7efe0b2c-1331-47fa-acef-836389d8ffcd/etsy-1.jpg","https://media.gemworkers.com/items/7efe0b2c-1331-47fa-acef-836389d8ffcd/etsy-2.jpg","https://media.gemworkers.com/items/7efe0b2c-1331-47fa-acef-836389d8ffcd/etsy-3.jpg","https://media.gemworkers.com/items/7efe0b2c-1331-47fa-acef-836389d8ffcd/etsy-4.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 120 USD, converted at ECB rate. Etsy tags: Santa Maria Cabochon,Blue Aquamarine,Unique Aquamarine,Rare Aquamarine,Aquamarine Cabochons,Bicolour Aquamarine,Bicolour Cabochons,Blue Cabochons,Lagoon Cabochons,Natural Stone,jewels,Oceangemsminerals,Rare Cabochons.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('928b9891-b7ee-4511-88cd-401da57150fe', '74.65 Cts Aquamarine Cabochon', 'big size Aquamarine Cabochon 

ethically sourced 

74.65 Cts
28.4 x 18.7 x 14.8mm

unheated, untreated m.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 134, 1, 'loose_stone', 'Aquamarine', NULL, 74.65, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/928b9891-b7ee-4511-88cd-401da57150fe/etsy-1.jpg","https://media.gemworkers.com/items/928b9891-b7ee-4511-88cd-401da57150fe/etsy-2.jpg","https://media.gemworkers.com/items/928b9891-b7ee-4511-88cd-401da57150fe/etsy-3.jpg","https://media.gemworkers.com/items/928b9891-b7ee-4511-88cd-401da57150fe/etsy-4.jpg","https://media.gemworkers.com/items/928b9891-b7ee-4511-88cd-401da57150fe/etsy-5.jpg","https://media.gemworkers.com/items/928b9891-b7ee-4511-88cd-401da57150fe/etsy-6.jpg","https://media.gemworkers.com/items/928b9891-b7ee-4511-88cd-401da57150fe/etsy-7.jpg","https://media.gemworkers.com/items/928b9891-b7ee-4511-88cd-401da57150fe/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 150 USD, converted at ECB rate. Etsy tags: Santa Maria Cabochon,Blue Aquamarine,Unique Aquamarine,Rare Aquamarine,Aquamarine Cabochons,Bicolour Aquamarine,Bicolour Cabochons,Blue Cabochons,Lagoon Cabochons,Natural Stone,jewels,Oceangemsminerals,Rare Cabochons.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('7f048b41-ebf9-4b97-8387-21eb30c780fb', 'RARE: 13.7 Cts, Bicolour Tourmaline Lot.', 'Pink And Neon Blue Colour Bicolour Afghan Tourmaline Lot

Exceptional

13.55 Cts
5 to 9mm

no treatment whatsoever', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 348, 1, 'loose_stone', 'Tourmaline', NULL, 13.7, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/7f048b41-ebf9-4b97-8387-21eb30c780fb/etsy-1.jpg","https://media.gemworkers.com/items/7f048b41-ebf9-4b97-8387-21eb30c780fb/etsy-2.jpg","https://media.gemworkers.com/items/7f048b41-ebf9-4b97-8387-21eb30c780fb/etsy-3.jpg","https://media.gemworkers.com/items/7f048b41-ebf9-4b97-8387-21eb30c780fb/etsy-4.jpg","https://media.gemworkers.com/items/7f048b41-ebf9-4b97-8387-21eb30c780fb/etsy-5.jpg","https://media.gemworkers.com/items/7f048b41-ebf9-4b97-8387-21eb30c780fb/etsy-6.jpg","https://media.gemworkers.com/items/7f048b41-ebf9-4b97-8387-21eb30c780fb/etsy-7.jpg","https://media.gemworkers.com/items/7f048b41-ebf9-4b97-8387-21eb30c780fb/etsy-8.jpg","https://media.gemworkers.com/items/7f048b41-ebf9-4b97-8387-21eb30c780fb/etsy-9.jpg","https://media.gemworkers.com/items/7f048b41-ebf9-4b97-8387-21eb30c780fb/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 390 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Rings,Natural Stone,Bicolour Tourmaline,Loose gemstones,Gold Rings,Rings For women,Rings For Men,y2k earrings stud,Oceangemsminerals,Lagoon Tourmaline,Blue Tourmaline,Pink Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('bc26e50f-fccd-41eb-b0aa-65b8d3c55177', 'Mix Colour Tourmaline Lot', 'Gorgeous Mesmerising Afghan Tourmaline lot,

Unique Colour, glossy and high lustre.

best for jewellery 

Clarity: Eye Clean And Loupe Clean

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 205, 1, 'loose_stone', 'Tourmaline', NULL, NULL, NULL, 'Afghanistan', 'Eye Clean And Loupe Clean', NULL, '["https://media.gemworkers.com/items/bc26e50f-fccd-41eb-b0aa-65b8d3c55177/etsy-1.jpg","https://media.gemworkers.com/items/bc26e50f-fccd-41eb-b0aa-65b8d3c55177/etsy-2.jpg","https://media.gemworkers.com/items/bc26e50f-fccd-41eb-b0aa-65b8d3c55177/etsy-3.jpg","https://media.gemworkers.com/items/bc26e50f-fccd-41eb-b0aa-65b8d3c55177/etsy-4.jpg","https://media.gemworkers.com/items/bc26e50f-fccd-41eb-b0aa-65b8d3c55177/etsy-5.jpg","https://media.gemworkers.com/items/bc26e50f-fccd-41eb-b0aa-65b8d3c55177/etsy-6.jpg","https://media.gemworkers.com/items/bc26e50f-fccd-41eb-b0aa-65b8d3c55177/etsy-7.jpg","https://media.gemworkers.com/items/bc26e50f-fccd-41eb-b0aa-65b8d3c55177/etsy-8.jpg","https://media.gemworkers.com/items/bc26e50f-fccd-41eb-b0aa-65b8d3c55177/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 230 USD, converted at ECB rate. Etsy tags: BlueGreen Tourmaline,Blue Tourmaline,Green Tourmaline,Lagoon Tourmaline,Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery findings,gift for her,natural stone,Oceangemsminerals,apple green colour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('b487b447-f7a0-4c35-91cb-7819b8813e36', '2.55 Cts Eye Clean Tourmalines', 'Afghan Tourmaline Lot 

Vibrant Colour

Bright And Lustre, 

Eye Clean 

2.55 Cts 
7x5.2x3.3mm 
7x6x3.4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 2.55, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/b487b447-f7a0-4c35-91cb-7819b8813e36/etsy-1.jpg","https://media.gemworkers.com/items/b487b447-f7a0-4c35-91cb-7819b8813e36/etsy-2.jpg","https://media.gemworkers.com/items/b487b447-f7a0-4c35-91cb-7819b8813e36/etsy-3.jpg","https://media.gemworkers.com/items/b487b447-f7a0-4c35-91cb-7819b8813e36/etsy-4.jpg","https://media.gemworkers.com/items/b487b447-f7a0-4c35-91cb-7819b8813e36/etsy-5.jpg","https://media.gemworkers.com/items/b487b447-f7a0-4c35-91cb-7819b8813e36/etsy-6.jpg","https://media.gemworkers.com/items/b487b447-f7a0-4c35-91cb-7819b8813e36/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('953aec14-d3c7-41e3-8dd1-9e0728874e75', '31 Cts Pink Tourmaline Cabochon Lot', 'Gorgeous Pink Tourmaline Cabochon Lot

High Lustre And Nice Polished, 

31 Cts
6 to 13.5mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 143, 1, 'loose_stone', 'Tourmaline', NULL, 31, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/953aec14-d3c7-41e3-8dd1-9e0728874e75/etsy-1.jpg","https://media.gemworkers.com/items/953aec14-d3c7-41e3-8dd1-9e0728874e75/etsy-2.jpg","https://media.gemworkers.com/items/953aec14-d3c7-41e3-8dd1-9e0728874e75/etsy-3.jpg","https://media.gemworkers.com/items/953aec14-d3c7-41e3-8dd1-9e0728874e75/etsy-4.jpg","https://media.gemworkers.com/items/953aec14-d3c7-41e3-8dd1-9e0728874e75/etsy-5.jpg","https://media.gemworkers.com/items/953aec14-d3c7-41e3-8dd1-9e0728874e75/etsy-6.jpg","https://media.gemworkers.com/items/953aec14-d3c7-41e3-8dd1-9e0728874e75/etsy-7.jpg","https://media.gemworkers.com/items/953aec14-d3c7-41e3-8dd1-9e0728874e75/etsy-8.jpg","https://media.gemworkers.com/items/953aec14-d3c7-41e3-8dd1-9e0728874e75/etsy-9.jpg","https://media.gemworkers.com/items/953aec14-d3c7-41e3-8dd1-9e0728874e75/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 160 USD, converted at ECB rate. Etsy tags: Santa Maria Cabochon,Bicolour Cabochons,Blue Cabochons,Lagoon Cabochons,Natural Stone,jewels,Oceangemsminerals,Tourmaline Rosecuts,Lagoon Rosecuts,Blue Tourmaline,Blue Rosecuts,Green Cabochons,Pink Cabochons.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('084006eb-5c10-4950-a393-cec514881576', '21.70 Cts BlueGreen Tourmaline Cabochon Lot', 'Gorgeous High Lustre Cabochon Blue Green Colour Tourmaline Cabochons

21.70 Cts
5.5 to 9mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 143, 1, 'loose_stone', 'Tourmaline', NULL, 21.7, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/084006eb-5c10-4950-a393-cec514881576/etsy-1.jpg","https://media.gemworkers.com/items/084006eb-5c10-4950-a393-cec514881576/etsy-2.jpg","https://media.gemworkers.com/items/084006eb-5c10-4950-a393-cec514881576/etsy-3.jpg","https://media.gemworkers.com/items/084006eb-5c10-4950-a393-cec514881576/etsy-4.jpg","https://media.gemworkers.com/items/084006eb-5c10-4950-a393-cec514881576/etsy-5.jpg","https://media.gemworkers.com/items/084006eb-5c10-4950-a393-cec514881576/etsy-6.jpg","https://media.gemworkers.com/items/084006eb-5c10-4950-a393-cec514881576/etsy-7.jpg","https://media.gemworkers.com/items/084006eb-5c10-4950-a393-cec514881576/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 160 USD, converted at ECB rate. Etsy tags: Rings For Men,Tourmaline Jewellery,Natural Stone,bicolour Tourmaline,Lagoon tourmaline,Bluegreen tourmaline,blue tourmaline,tourmaline rings,faceted tourmaline,Oceangemsminerals,Paraiba Tourmaline,Paraiba Cabochon,Blue Cabochons.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('8deea099-ac6a-41e4-b914-28a0ca8d3c41', '29 Cts Pink Tourmaline Cabochon Lot', 'Gorgeous Pink Colour Tourmaline Cabochon Lot

High Lustre And Nice Polished

29 Cts
5.5 to 9.5mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 178, 1, 'loose_stone', 'Tourmaline', NULL, 29, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/8deea099-ac6a-41e4-b914-28a0ca8d3c41/etsy-1.jpg","https://media.gemworkers.com/items/8deea099-ac6a-41e4-b914-28a0ca8d3c41/etsy-2.jpg","https://media.gemworkers.com/items/8deea099-ac6a-41e4-b914-28a0ca8d3c41/etsy-3.jpg","https://media.gemworkers.com/items/8deea099-ac6a-41e4-b914-28a0ca8d3c41/etsy-4.jpg","https://media.gemworkers.com/items/8deea099-ac6a-41e4-b914-28a0ca8d3c41/etsy-5.jpg","https://media.gemworkers.com/items/8deea099-ac6a-41e4-b914-28a0ca8d3c41/etsy-6.jpg","https://media.gemworkers.com/items/8deea099-ac6a-41e4-b914-28a0ca8d3c41/etsy-7.jpg","https://media.gemworkers.com/items/8deea099-ac6a-41e4-b914-28a0ca8d3c41/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 199 USD, converted at ECB rate. Etsy tags: Santa Maria Cabochon,Bicolour Cabochons,Blue Cabochons,Lagoon Cabochons,Natural Stone,jewels,Oceangemsminerals,Tourmaline Rosecuts,Lagoon Rosecuts,Blue Tourmaline,Blue Rosecuts,Pink Cabochon,Green Cabochon.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('dfda66cd-7e87-438b-ae43-6c6b86fb07cd', '46 Cts Pink Tourmaline Cabochon Lot', 'Gorgeous Pink Colour Tourmaline Cabochon Lot

High Lustre And Nice Polished

46 Cts
7 to 15mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 241, 1, 'loose_stone', 'Tourmaline', NULL, 46, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/dfda66cd-7e87-438b-ae43-6c6b86fb07cd/etsy-1.jpg","https://media.gemworkers.com/items/dfda66cd-7e87-438b-ae43-6c6b86fb07cd/etsy-2.jpg","https://media.gemworkers.com/items/dfda66cd-7e87-438b-ae43-6c6b86fb07cd/etsy-3.jpg","https://media.gemworkers.com/items/dfda66cd-7e87-438b-ae43-6c6b86fb07cd/etsy-4.jpg","https://media.gemworkers.com/items/dfda66cd-7e87-438b-ae43-6c6b86fb07cd/etsy-5.jpg","https://media.gemworkers.com/items/dfda66cd-7e87-438b-ae43-6c6b86fb07cd/etsy-6.jpg","https://media.gemworkers.com/items/dfda66cd-7e87-438b-ae43-6c6b86fb07cd/etsy-7.jpg","https://media.gemworkers.com/items/dfda66cd-7e87-438b-ae43-6c6b86fb07cd/etsy-8.jpg","https://media.gemworkers.com/items/dfda66cd-7e87-438b-ae43-6c6b86fb07cd/etsy-9.jpg","https://media.gemworkers.com/items/dfda66cd-7e87-438b-ae43-6c6b86fb07cd/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 270 USD, converted at ECB rate. Etsy tags: Santa Maria Cabochon,Bicolour Cabochons,Blue Cabochons,Lagoon Cabochons,Natural Stone,jewels,Oceangemsminerals,Tourmaline Rosecuts,Lagoon Rosecuts,Blue Tourmaline,Blue Rosecuts,Pink Cabochon,Green Cabochon.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('fb259af8-f0bb-4f42-a40b-936a74daca31', '2.80 Cts, Apple Green Tourmaline', 'Mesmerising Mint Green Colour Afghan Tourmaline 

Ethically Sourced, Almost Eye Clean

high lustre 

2.80 Cts
9.7 x 6.8 x 4.6mm

Unheated, No treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 107, 1, 'loose_stone', 'Tourmaline', NULL, 2.8, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/fb259af8-f0bb-4f42-a40b-936a74daca31/etsy-1.jpg","https://media.gemworkers.com/items/fb259af8-f0bb-4f42-a40b-936a74daca31/etsy-2.jpg","https://media.gemworkers.com/items/fb259af8-f0bb-4f42-a40b-936a74daca31/etsy-3.jpg","https://media.gemworkers.com/items/fb259af8-f0bb-4f42-a40b-936a74daca31/etsy-4.jpg","https://media.gemworkers.com/items/fb259af8-f0bb-4f42-a40b-936a74daca31/etsy-5.jpg","https://media.gemworkers.com/items/fb259af8-f0bb-4f42-a40b-936a74daca31/etsy-6.jpg","https://media.gemworkers.com/items/fb259af8-f0bb-4f42-a40b-936a74daca31/etsy-7.jpg","https://media.gemworkers.com/items/fb259af8-f0bb-4f42-a40b-936a74daca31/etsy-8.jpg","https://media.gemworkers.com/items/fb259af8-f0bb-4f42-a40b-936a74daca31/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 120 USD, converted at ECB rate. Etsy tags: Jewellery Making,Rings For Women,Jewellery Finding,Rings For Men,Jewels,Gold Rings,Jewellery Supplies,Gift For Her,Natural Stone,Blue tourmaline,lagoon Tourmaline,Oceangemsminerals,AppleGreenTourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('a816a6ff-0f8a-4e21-ade1-0c9ce9a0813a', '4.25 Cts, Blue And Green Tourmaline Lot', 'Blue And Green Tourmaline 

Bright And Lustrous 

4.25 Cts
8.7 to 4.7mm

ethically sourced 

no treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 107, 1, 'loose_stone', 'Tourmaline', NULL, 4.25, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/a816a6ff-0f8a-4e21-ade1-0c9ce9a0813a/etsy-1.jpg","https://media.gemworkers.com/items/a816a6ff-0f8a-4e21-ade1-0c9ce9a0813a/etsy-2.jpg","https://media.gemworkers.com/items/a816a6ff-0f8a-4e21-ade1-0c9ce9a0813a/etsy-3.jpg","https://media.gemworkers.com/items/a816a6ff-0f8a-4e21-ade1-0c9ce9a0813a/etsy-4.jpg","https://media.gemworkers.com/items/a816a6ff-0f8a-4e21-ade1-0c9ce9a0813a/etsy-5.jpg","https://media.gemworkers.com/items/a816a6ff-0f8a-4e21-ade1-0c9ce9a0813a/etsy-6.jpg","https://media.gemworkers.com/items/a816a6ff-0f8a-4e21-ade1-0c9ce9a0813a/etsy-7.jpg","https://media.gemworkers.com/items/a816a6ff-0f8a-4e21-ade1-0c9ce9a0813a/etsy-8.jpg","https://media.gemworkers.com/items/a816a6ff-0f8a-4e21-ade1-0c9ce9a0813a/etsy-9.jpg","https://media.gemworkers.com/items/a816a6ff-0f8a-4e21-ade1-0c9ce9a0813a/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 120 USD, converted at ECB rate. Etsy tags: jewellerymaking,blue tourmaline,natural stone,IndicoliteTourmaline,Tourmaline Lot,Blue Tourmaline Lot,Rare Tourmaline,Oceangemsminerals,Jewels,Jewellery Making,Jewellery Supplies,Lagoon Tourmaline,Jewelers.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('0bdac18c-6236-48b6-a00f-a1c740db3edf', '1.84 Cts Blue And Bicolour Tourmaline', 'Top Blue And Pink Colour Tourmaline Emerald Cut 

1.84 Cts
7.5 x 5.5 x 5mm

rare find

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 267, 1, 'loose_stone', 'Tourmaline', NULL, 1.84, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/0bdac18c-6236-48b6-a00f-a1c740db3edf/etsy-1.jpg","https://media.gemworkers.com/items/0bdac18c-6236-48b6-a00f-a1c740db3edf/etsy-2.jpg","https://media.gemworkers.com/items/0bdac18c-6236-48b6-a00f-a1c740db3edf/etsy-3.jpg","https://media.gemworkers.com/items/0bdac18c-6236-48b6-a00f-a1c740db3edf/etsy-4.jpg","https://media.gemworkers.com/items/0bdac18c-6236-48b6-a00f-a1c740db3edf/etsy-5.jpg","https://media.gemworkers.com/items/0bdac18c-6236-48b6-a00f-a1c740db3edf/etsy-6.jpg","https://media.gemworkers.com/items/0bdac18c-6236-48b6-a00f-a1c740db3edf/etsy-7.jpg","https://media.gemworkers.com/items/0bdac18c-6236-48b6-a00f-a1c740db3edf/etsy-8.jpg","https://media.gemworkers.com/items/0bdac18c-6236-48b6-a00f-a1c740db3edf/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 299 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('882d459f-4f15-4ab3-bb8d-fcb4069257a1', '1.50 Cts Blue And Bicolour Tourmaline', 'Top Blue And Pink Colour Tourmaline Emerald Cut 

1.50 Cts
10.5 x 4.2 x 3.5mm

rare find

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 267, 1, 'loose_stone', 'Tourmaline', NULL, 1.5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/882d459f-4f15-4ab3-bb8d-fcb4069257a1/etsy-1.jpg","https://media.gemworkers.com/items/882d459f-4f15-4ab3-bb8d-fcb4069257a1/etsy-2.jpg","https://media.gemworkers.com/items/882d459f-4f15-4ab3-bb8d-fcb4069257a1/etsy-3.jpg","https://media.gemworkers.com/items/882d459f-4f15-4ab3-bb8d-fcb4069257a1/etsy-4.jpg","https://media.gemworkers.com/items/882d459f-4f15-4ab3-bb8d-fcb4069257a1/etsy-5.jpg","https://media.gemworkers.com/items/882d459f-4f15-4ab3-bb8d-fcb4069257a1/etsy-6.jpg","https://media.gemworkers.com/items/882d459f-4f15-4ab3-bb8d-fcb4069257a1/etsy-7.jpg","https://media.gemworkers.com/items/882d459f-4f15-4ab3-bb8d-fcb4069257a1/etsy-8.jpg","https://media.gemworkers.com/items/882d459f-4f15-4ab3-bb8d-fcb4069257a1/etsy-9.jpg","https://media.gemworkers.com/items/882d459f-4f15-4ab3-bb8d-fcb4069257a1/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 299 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('4999e04e-7b75-48c8-8df6-4ac8a8df0c16', '3 Cts, Natural Bicolour Afghan Tourmaline Pair', 'Gorgeous Mesmerising Natural Bicolour Afghan Tourmaline pair

high lustre, Saturated Colour.

3 Cts
7.5 x 5.5 x 3.9mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 143, 1, 'loose_stone', 'Tourmaline', NULL, 3, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/4999e04e-7b75-48c8-8df6-4ac8a8df0c16/etsy-1.jpg","https://media.gemworkers.com/items/4999e04e-7b75-48c8-8df6-4ac8a8df0c16/etsy-2.jpg","https://media.gemworkers.com/items/4999e04e-7b75-48c8-8df6-4ac8a8df0c16/etsy-3.jpg","https://media.gemworkers.com/items/4999e04e-7b75-48c8-8df6-4ac8a8df0c16/etsy-4.jpg","https://media.gemworkers.com/items/4999e04e-7b75-48c8-8df6-4ac8a8df0c16/etsy-5.jpg","https://media.gemworkers.com/items/4999e04e-7b75-48c8-8df6-4ac8a8df0c16/etsy-6.jpg","https://media.gemworkers.com/items/4999e04e-7b75-48c8-8df6-4ac8a8df0c16/etsy-7.jpg","https://media.gemworkers.com/items/4999e04e-7b75-48c8-8df6-4ac8a8df0c16/etsy-8.jpg","https://media.gemworkers.com/items/4999e04e-7b75-48c8-8df6-4ac8a8df0c16/etsy-9.jpg","https://media.gemworkers.com/items/4999e04e-7b75-48c8-8df6-4ac8a8df0c16/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 160 USD, converted at ECB rate. Etsy tags: Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery findings,gift for her,natural stone,Oceangemsminerals,apple green colour,Bicolour Tourmaline,Natural Bicolour,Unheated Tourmaline,Lipstick Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
-- Check: drafts for this seller, all unlisted
SELECT count(*) AS drafts, count(*) FILTER (WHERE is_listed) AS listed, sum(jsonb_array_length(image_urls)) AS photos FROM public.inventory_items WHERE seller_id = 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd' AND notes LIKE 'Imported from Etsy%';
COMMIT;
