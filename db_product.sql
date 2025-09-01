CREATE TABLE products (
  id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(255),
  image TEXT,
  price DECIMAL(10,2),
  description TEXT,
  brand VARCHAR(100),
  color VARCHAR(50),
  category VARCHAR(100)
);

INSERT INTO products (title, image, price, description, brand, color, category) VALUES
('Clinique Redness Solutions Makeup SPF 15', 'https://www.clinique.com.au/media/export/cms/products/402x464/clq_70JW_402x464.png', 'clinique', 'Calming Honey', 'foundation'),
('Clinique Stay-Matte Oil-Free Makeup', 'https://canadianbeauty.com/wp-content/uploads/2012/05/Stay-Matte-Oil-Free-Makeup-FINAL.jpg', 26.00, 'Long-wearing matte foundation for oily skin types.', 'clinique', 'CN 08 Linen', 'foundation'),
('ColourPop Lippie Pencil', 'https://colourpop.com/cdn/shop/files/Top-Down-Lippie-Pencil-with-Cap.jpg?v=1689727385', 5.00, 'A creamy pencil that glides on smoothly and lasts all day.', 'colourpop', 'Dusty roses', 'lip_liner'),
('ColourPop Blotted Lip', 'https://colourpop.com/cdn/shop/files/5-18-23-Ultra-Lip-Upgrade-Web-Assets-Infographic-Blotted_7cf4dbf1-b582-4cf4-b09d-cfc5a28578d0.jpg?v=1687292076', 5.50, 'Lightweight lipstick with a soft, diffused matte finish.', 'colourpop', 'pink', 'lipstick'),
('Clinique Advanced Concealer', 'https://dy6g3i6a1660s.cloudfront.net/kosCiYH2Qlf4vtOtV3IqYQHCAcI/p_550x550-30/clinique-advanced-concealer-matte-light-.jpg', 20.00, 'Full coverage concealer that stays put for hours.', 'clinique', 'Light neutral', 'concealer'),
('Maybelline Face Studio Master Hi-Light Bronzer', 'https://myfindsonline.com/wp-content/uploads/2015/05/facestudio-bronzer.jpg', 14.99, 'Multi-tonal bronzer for a radiant sun-kissed look.', 'maybelline', 'Light brown', 'bronzer'),
('Maybelline Face Studio Master Hi-Light Blush', 'https://i5.walmartimages.com/seo/Maybelline-Face-Studio-Master-Hi-Light-Blush-Coral_68afde5e-c12b-41cc-809b-b4256d6d35b0.77e806792e236c0aabc67afe4f4fa587.jpeg', 9.50, 'Volumizing mascara that delivers a wide-eyed doll lash look.', 'maybelline', NULL, 'mascara'),
('Benefit Hoola Matte Bronzer', 'https://cdn.nicehair.dk/products/75572/benefit-hoola-matte-powder-bronzer-8-gr-1.jpg', 29.00, 'Award-winning matte bronzer for a natural sun-kissed glow.', 'benefit', 'light', 'bronzer'),  
('Smashbox Photo Finish Foundation Primer', 'https://images.matas.dk/Assets_v3/300001-400000/371001-372000/371401-371500/371458/product_v1_x4.jpg', 36.00, 'Silky primer that blurs imperfections and smooths skin.', 'smashbox', 'white', 'primer'),
('CoverGirl LashBlast Volume Mascara', 'https://media1.popsugar-assets.com/files/thumbor/uJ-bknbuCZvb8A0vrloaSK_earg/fit-in/1024x1024/filters:format_auto-!!-:strip_icc-!!-/2017/12/14/972/n/1922153/3b95ee065a32f9274d7495.40151005_covergirl/i/CoverGirl-LashBlast-Volume-Waterproof-Mascara.jpg', 8.99, 'Mega-volume mascara for bold, full lashes.', 'covergirl', 'orange', 'mascara'),
('Dior Diorskin Forever Undercover Foundation', 'https://i5.walmartimages.com/asr/c33b77a6-3010-4c60-bc01-30b86feee8e8.a1cfee8a0cb4b6e6f58b424da04c1666.jpeg', 52.00, 'Full coverage foundation with a lightweight matte finish.', 'dior', 'pink', 'foundation'),
('NYX Butter Gloss', 'https://www.clinique.com/media/export/cms/products/600x750/cl_sku_749K04_600x750_0.png', 5.00, 'Buttery soft gloss that delivers sheer to medium coverage.', 'nyx', 'light pink', 'lip_gloss'),
('Clinique Chubby Stick Lip Balm', 'https://media1.popsugar-assets.com/files/thumbor/gpu8FKxPkivk4zBeBl2Mam8SaaM/fit-in/1024x1024/filters:format_auto-!!-:strip_icc-!!-/2019/04/09/731/n/1922153/32c379418ea5f78f_netimgFYizuJ/i/Clinique-Chubby-Stick-Moisturizing-Lip-Colour-Balm.jpg', 17.00, 'Moisturizing lip balm with a sheer hint of color.', 'clinique', 'orange', 'lip_balm'),
('Benefit They are Real! Mascara', 'https://media.ulta.com/i/ulta/2231443?w=720&fmt=png', 25.00, 'Lengthens, curls, volumizes and lifts lashes.', 'benefit', 'grey', 'mascara'),  
('Smashbox Always On Liquid Lipstick', 'https://media.ulta.com/i/ulta/2306282?w=720&fmt=png', 24.00, 'Weightless matte liquid lipstick that stays put for 8 hours.', 'smashbox', 'rossie', 'lipstick'),
('CoverGirl Clean Matte BB Cream', 'https://owp.klarna.com/product/1200x630/3004646167/CoverGirl-Clean-Matte-BB-Cream-Fair.jpg', 8.49, 'Oil-free BB cream for a fresh, natural look.', 'covergirl', 'light', 'bb_cream'),
('Dior Addict Lip Glow', 'https://www.1-minute-reads.com/wp-content/uploads/2020/11/dior-addict-lip-glow-large.png', 34.00, 'Color reviving lip balm that enhances your natural lip tone.', 'dior', 'pink', 'lip_balm'),
('NYX Micro Brow Pencil', 'https://titounebeautystyle.com/wp-content/uploads/2017/08/micro_brow_pencil_nyx_espresso.jpg', 10.00, 'Precise brow pencil for natural-looking definition.', 'nyx', 'brown', 'eyebrow'),
('Clinique Even Better Makeup SPF 15', 'https://www.raincouverbeauty.com/wp-content/uploads/2019/04/Clinique-Even-Better-WN-04-Bone-Review-963x1024.jpg', 29.00, 'Foundation that evens skin tone and improves clarity.', 'clinique', 'light', 'foundation');



--CREATE TABLE users 
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO users (id, first_name, last_name, email, username, password ) VALUES
(1, 'John', 'Doe', 'tmi@gmail.com', 'johndoe', '$password123');


CREATE TABLE likes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  product_id INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (product_id) REFERENCES products(id),
  UNIQUE KEY unique_like (user_id, product_id)
);

CREATE TABLE comments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  product_id INT,
  content TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (product_id) REFERENCES products(id)
);
