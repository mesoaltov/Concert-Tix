-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Feb 04, 2026 at 02:03 PM
-- Server version: 10.11.15-MariaDB-cll-lve
-- PHP Version: 8.4.17

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `tifj4825_db_altov`
--

-- --------------------------------------------------------

--
-- Table structure for table `concerts`
--

CREATE TABLE `concerts` (
  `id` int(11) NOT NULL,
  `title` varchar(120) NOT NULL,
  `artist` varchar(120) NOT NULL,
  `date` varchar(30) NOT NULL,
  `time` varchar(10) NOT NULL,
  `city` varchar(60) NOT NULL,
  `venue` varchar(120) NOT NULL,
  `price` int(11) NOT NULL,
  `category` varchar(30) DEFAULT 'Tribun',
  `poster_url` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `concerts`
--

INSERT INTO `concerts` (`id`, `title`, `artist`, `date`, `time`, `city`, `venue`, `price`, `category`, `poster_url`) VALUES
(1, 'WIDE EYES OPEN 1st Tour', 'Close Your Eyes', '12 Desember 2025', '18:00', 'Jakarta', 'Gelora Bung Karno', 1500000, 'Tribun', ''),
(2, 'IShowU!', 'f5ve', '4 Februari 2026', '18:00 JST', 'Saitama', 'Saitama Super Area', 700000, 'Tribun', 'https://altov.tif-lbj.my.id/api-altov/images/f5ve_ishowu.jpg'),
(3, 'Say it DITTO!', 'NewJeans', '15 Maret 2026', '18:30', 'Jakarta', 'Gelora Bung Karno', 2000000, 'Tribun', 'https://altov.tif-lbj.my.id/api-altov/images/newjeans_ditto.jpg'),
(4, 'Xtrong Girlz', 'XG', '19 Maret 2026', '18:00', 'Tokyo, Japan', 'Tokyo Dome', 2500000, 'Standing', 'https://altov.tif-lbj.my.id/api-altov/images/xg_girlz.jpg'),
(5, 'dest', 'sss', '12-18-15kjsjsjsjsjs', 'hshhs', 'bali', 'sdsd', 3333, '333', 'eee');

-- --------------------------------------------------------

--
-- Table structure for table `favorites`
--

CREATE TABLE `favorites` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `concert_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `favorites`
--

INSERT INTO `favorites` (`id`, `user_id`, `concert_id`, `created_at`) VALUES
(2, 2, 3, '2026-01-16 13:20:26'),
(4, 1, 2, '2026-01-26 10:17:52');

-- --------------------------------------------------------

--
-- Table structure for table `tickets`
--

CREATE TABLE `tickets` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `concert_id` int(11) NOT NULL,
  `qty` int(11) NOT NULL,
  `total_price` int(11) NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'Booked',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tickets`
--

INSERT INTO `tickets` (`id`, `user_id`, `concert_id`, `qty`, `total_price`, `status`, `created_at`) VALUES
(1, 1, 1, 1, 1500000, 'Canceled', '2026-01-06 13:41:16'),
(2, 2, 2, 2, 1400000, 'Booked', '2026-01-16 13:20:07'),
(3, 2, 3, 2, 4000000, 'Booked', '2026-01-22 12:32:52'),
(4, 3, 2, 1, 700000, 'Canceled', '2026-01-22 14:47:21');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `full_name` varchar(100) NOT NULL DEFAULT '',
  `password` varchar(255) NOT NULL,
  `role` varchar(10) NOT NULL DEFAULT 'user'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `full_name`, `password`, `role`) VALUES
(1, 'admin', '', '12345', 'admin'),
(2, 'altov', '', '12345', 'user'),
(3, 'agam', '', '12345', 'user'),
(4, 'test', '', '1234', 'user'),
(5, 'ibra', 'Maulana Ibrahim', '123', 'user');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `concerts`
--
ALTER TABLE `concerts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `favorites`
--
ALTER TABLE `favorites`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_fav` (`user_id`,`concert_id`),
  ADD UNIQUE KEY `uniq_fav` (`user_id`,`concert_id`),
  ADD KEY `concert_id` (`concert_id`);

--
-- Indexes for table `tickets`
--
ALTER TABLE `tickets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `concert_id` (`concert_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `concerts`
--
ALTER TABLE `concerts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `favorites`
--
ALTER TABLE `favorites`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tickets`
--
ALTER TABLE `tickets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `favorites`
--
ALTER TABLE `favorites`
  ADD CONSTRAINT `favorites_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `favorites_ibfk_2` FOREIGN KEY (`concert_id`) REFERENCES `concerts` (`id`);

--
-- Constraints for table `tickets`
--
ALTER TABLE `tickets`
  ADD CONSTRAINT `tickets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `tickets_ibfk_2` FOREIGN KEY (`concert_id`) REFERENCES `concerts` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
