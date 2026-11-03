-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Oct 16, 2026 at 10:15 PM
-- Server version: 10.3.39-MariaDB
-- PHP Version: 8.1.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `myreportxbd_update`
--

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(191) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(191) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `modarator_of_users`
--

CREATE TABLE `modarator_of_users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `modarator_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `accept_request` int(11) NOT NULL DEFAULT 0,
  `active` int(11) NOT NULL DEFAULT 0,
  `status` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `modarator_sugession_to_users`
--

CREATE TABLE `modarator_sugession_to_users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `modarator_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `sugession` text DEFAULT NULL,
  `month` timestamp NULL DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `monthly_plans`
--

CREATE TABLE `monthly_plans` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `month` varchar(191) NOT NULL,
  `quran_days` int(11) DEFAULT NULL,
  `surah_name` varchar(191) DEFAULT NULL,
  `quran_ayat` int(11) DEFAULT NULL,
  `quran_avg_ayat` double(8,2) DEFAULT NULL,
  `quran_darz` int(11) DEFAULT NULL,
  `surah_meaning` int(11) DEFAULT NULL,
  `hadith_days` int(11) DEFAULT NULL,
  `hadith_topics` varchar(191) DEFAULT NULL,
  `hadith_memorize` varchar(191) DEFAULT NULL,
  `hadith_avg` double(8,2) DEFAULT NULL,
  `hadith_darz` int(11) DEFAULT NULL,
  `hadith_subjects` varchar(191) DEFAULT NULL,
  `literature_pages` int(11) DEFAULT NULL,
  `literature_islamic` int(11) DEFAULT NULL,
  `literature_others` int(11) DEFAULT NULL,
  `literature_book_name` varchar(191) DEFAULT NULL,
  `literature_book_note` varchar(191) DEFAULT NULL,
  `literature_book` text DEFAULT NULL,
  `literature_discussion` varchar(191) DEFAULT NULL,
  `general_book_days` int(11) DEFAULT NULL,
  `class_attendance` int(11) DEFAULT NULL,
  `attendance_total_days` int(11) DEFAULT NULL,
  `jamayat_namaz` varchar(191) DEFAULT NULL,
  `nafal_namaz` varchar(191) DEFAULT NULL,
  `dawat_days` int(11) DEFAULT NULL,
  `dawat_total_hours` double(8,2) DEFAULT NULL,
  `dawat_person` int(11) DEFAULT NULL,
  `org_work_days` int(11) DEFAULT NULL,
  `org_work_avg_hours` double(8,2) DEFAULT NULL,
  `contact_member` int(11) DEFAULT NULL,
  `contact_supporter` int(11) DEFAULT NULL,
  `school_student` int(11) DEFAULT NULL,
  `contact_vip` int(11) DEFAULT NULL,
  `contact_associate` int(11) DEFAULT NULL,
  `contact_friend` int(11) DEFAULT NULL,
  `contact_talent` int(11) DEFAULT NULL,
  `contact_worker` int(11) DEFAULT NULL,
  `contact_wellwisher` int(11) DEFAULT NULL,
  `contact_teacher` int(11) DEFAULT NULL,
  `distribution_islamic_literature` int(11) DEFAULT NULL,
  `distribution_chhatrasangbad` int(11) DEFAULT NULL,
  `class_routine` int(11) DEFAULT NULL,
  `distribution_kishor_paper` int(11) DEFAULT NULL,
  `distribution_perspective` int(11) DEFAULT NULL,
  `sticker_card` int(11) DEFAULT NULL,
  `distribution_english_paper` int(11) DEFAULT NULL,
  `distribution_porichiti` int(11) DEFAULT NULL,
  `gift_sms_email` int(11) DEFAULT NULL,
  `increase_member1` int(11) DEFAULT NULL,
  `increase_member2` varchar(191) DEFAULT NULL,
  `activist1` int(11) DEFAULT NULL,
  `activist2` varchar(191) DEFAULT NULL,
  `member_elect1` int(11) DEFAULT NULL,
  `member_elect2` varchar(191) DEFAULT NULL,
  `supporter1` int(11) DEFAULT NULL,
  `supporter2` varchar(191) DEFAULT NULL,
  `increase_sathi1` int(11) DEFAULT NULL,
  `increase_sathi2` varchar(191) DEFAULT NULL,
  `increase_friend1` int(11) DEFAULT NULL,
  `increase_friend2` varchar(191) DEFAULT NULL,
  `sathi_elect1` int(11) DEFAULT NULL,
  `sathi_elect2` varchar(191) DEFAULT NULL,
  `card_wisher1` int(11) DEFAULT NULL,
  `card_wisher2` varchar(191) DEFAULT NULL,
  `bm_given_date` varchar(100) DEFAULT NULL,
  `personal_increase` int(11) DEFAULT NULL,
  `student_welfare` int(11) DEFAULT NULL,
  `kolsi_hari` int(11) DEFAULT NULL,
  `baitulmal_total` int(11) DEFAULT NULL,
  `table_bank` double(8,2) DEFAULT NULL,
  `baitulmal_others` int(11) DEFAULT NULL,
  `self_criticism` int(11) DEFAULT NULL,
  `muharama_contact` int(11) DEFAULT NULL,
  `dawat_email` int(11) DEFAULT NULL,
  `computer_learning` int(11) DEFAULT NULL,
  `language_learning` int(11) DEFAULT NULL,
  `physical_exercise` int(11) DEFAULT NULL,
  `group_dawat` int(11) DEFAULT NULL,
  `nonmuslim_contact` int(11) DEFAULT NULL,
  `manifold_newspaper` int(11) DEFAULT NULL,
  `dawat_sms` int(11) DEFAULT NULL,
  `contact_organization` int(11) DEFAULT NULL,
  `manifold_others` varchar(191) DEFAULT NULL,
  `opinion` varchar(191) DEFAULT NULL,
  `report_checking` varchar(191) DEFAULT NULL,
  `report_checking_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `monthly_reports`
--

CREATE TABLE `monthly_reports` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `month` varchar(191) NOT NULL,
  `quran_days` int(11) DEFAULT NULL,
  `surah_name` varchar(191) DEFAULT NULL,
  `quran_ayat` int(11) DEFAULT NULL,
  `quran_avg_ayat` double(8,2) DEFAULT NULL,
  `quran_darz` int(11) DEFAULT NULL,
  `surah_meaning` int(11) DEFAULT NULL,
  `hadith_days` int(11) DEFAULT NULL,
  `hadith_topics` varchar(191) DEFAULT NULL,
  `hadith_memorize` varchar(191) DEFAULT NULL,
  `hadith_avg` double(8,2) DEFAULT NULL,
  `hadith_darz` int(11) DEFAULT NULL,
  `hadith_subjects` varchar(191) DEFAULT NULL,
  `literature_pages` int(11) DEFAULT NULL,
  `literature_islamic` int(11) DEFAULT NULL,
  `literature_others` int(11) DEFAULT NULL,
  `literature_book_name` varchar(191) DEFAULT NULL,
  `literature_book_note` varchar(191) DEFAULT NULL,
  `literature_book` text DEFAULT NULL,
  `literature_discussion` varchar(191) DEFAULT NULL,
  `general_book_days` int(11) DEFAULT NULL,
  `general_book_total_hours` float DEFAULT NULL,
  `general_book_avg` varchar(100) DEFAULT NULL,
  `class_attendance` int(11) DEFAULT NULL,
  `attendance_total_days` int(11) DEFAULT NULL,
  `jamayat_namaz` varchar(191) DEFAULT NULL,
  `salat_kaja` int(11) DEFAULT NULL,
  `nafal_namaz` varchar(191) DEFAULT NULL,
  `dawat_days` int(11) DEFAULT NULL,
  `dawat_total_hours` varchar(100) DEFAULT NULL,
  `dawat_person` int(11) DEFAULT NULL,
  `org_work_days` int(11) DEFAULT NULL,
  `org_work_avg_hours` varchar(100) DEFAULT NULL,
  `contact_member` int(11) DEFAULT NULL,
  `contact_supporter` int(11) DEFAULT NULL,
  `school_student` int(11) DEFAULT NULL,
  `contact_vip` int(11) DEFAULT NULL,
  `contact_associate` int(11) DEFAULT NULL,
  `contact_friend` int(11) DEFAULT NULL,
  `contact_talent` int(11) DEFAULT NULL,
  `contact_worker` int(11) DEFAULT NULL,
  `contact_wellwisher` int(11) DEFAULT NULL,
  `contact_teacher` int(11) DEFAULT NULL,
  `distribution_islamic_literature` int(11) DEFAULT NULL,
  `distribution_chhatrasangbad` int(11) DEFAULT NULL,
  `class_routine` int(11) DEFAULT NULL,
  `distribution_kishor_paper` int(11) DEFAULT NULL,
  `distribution_perspective` int(11) DEFAULT NULL,
  `sticker_card` int(11) DEFAULT NULL,
  `distribution_english_paper` int(11) DEFAULT NULL,
  `distribution_porichiti` int(11) DEFAULT NULL,
  `gift_sms_email` int(11) DEFAULT NULL,
  `increase_member1` int(11) DEFAULT NULL,
  `increase_member2` varchar(191) DEFAULT NULL,
  `activist1` int(11) DEFAULT NULL,
  `activist2` varchar(191) DEFAULT NULL,
  `member_elect1` int(11) DEFAULT NULL,
  `member_elect2` varchar(191) DEFAULT NULL,
  `supporter1` int(11) DEFAULT NULL,
  `supporter2` varchar(191) DEFAULT NULL,
  `increase_sathi1` int(11) DEFAULT NULL,
  `increase_sathi2` varchar(191) DEFAULT NULL,
  `increase_friend1` int(11) DEFAULT NULL,
  `increase_friend2` varchar(191) DEFAULT NULL,
  `sathi_elect1` int(11) DEFAULT NULL,
  `sathi_elect2` varchar(191) DEFAULT NULL,
  `card_wisher1` int(11) DEFAULT NULL,
  `card_wisher2` varchar(191) DEFAULT NULL,
  `bm_given_date` varchar(100) DEFAULT NULL,
  `personal_increase` int(11) DEFAULT NULL,
  `student_welfare` int(11) DEFAULT NULL,
  `kolsi_hari` int(11) DEFAULT NULL,
  `baitulmal_total` int(11) DEFAULT NULL,
  `table_bank` double(8,2) DEFAULT NULL,
  `baitulmal_others` int(11) DEFAULT NULL,
  `self_criticism` int(11) DEFAULT NULL,
  `muharama_contact` int(11) DEFAULT NULL,
  `dawat_email` int(11) DEFAULT NULL,
  `computer_learning` int(11) DEFAULT NULL,
  `language_learning` int(11) DEFAULT NULL,
  `physical_exercise` int(11) DEFAULT NULL,
  `group_dawat` int(11) DEFAULT NULL,
  `nonmuslim_contact` int(11) DEFAULT NULL,
  `manifold_newspaper` int(11) DEFAULT NULL,
  `dawat_sms` int(11) DEFAULT NULL,
  `contact_organization` int(11) DEFAULT NULL,
  `manifold_others` varchar(191) DEFAULT NULL,
  `opinion` varchar(191) DEFAULT NULL,
  `report_checking` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `oauth_access_tokens`
--

CREATE TABLE `oauth_access_tokens` (
  `id` varchar(100) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `client_id` char(36) NOT NULL,
  `name` varchar(191) DEFAULT NULL,
  `scopes` text DEFAULT NULL,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `oauth_auth_codes`
--

CREATE TABLE `oauth_auth_codes` (
  `id` varchar(100) NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `client_id` char(36) NOT NULL,
  `scopes` text DEFAULT NULL,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `oauth_clients`
--

CREATE TABLE `oauth_clients` (
  `id` char(36) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `name` varchar(191) NOT NULL,
  `secret` varchar(100) DEFAULT NULL,
  `provider` varchar(191) DEFAULT NULL,
  `redirect` text NOT NULL,
  `personal_access_client` tinyint(1) NOT NULL,
  `password_client` tinyint(1) NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `oauth_personal_access_clients`
--

CREATE TABLE `oauth_personal_access_clients` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `client_id` char(36) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `oauth_refresh_tokens`
--

CREATE TABLE `oauth_refresh_tokens` (
  `id` varchar(100) NOT NULL,
  `access_token_id` varchar(100) NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(191) NOT NULL,
  `token` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(191) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `report_columns`
--

CREATE TABLE `report_columns` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `serial` int(10) UNSIGNED DEFAULT NULL,
  `default` tinyint(4) NOT NULL DEFAULT 0,
  `creator` bigint(20) DEFAULT NULL,
  `parent` bigint(20) DEFAULT NULL,
  `en_name` varchar(100) DEFAULT NULL,
  `bn_name` varchar(100) DEFAULT NULL,
  `visibility` tinyint(4) NOT NULL DEFAULT 1,
  `input_type` varchar(100) DEFAULT NULL,
  `value_type` varchar(100) DEFAULT NULL,
  `slug` varchar(50) DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `report_column_visibilities`
--

CREATE TABLE `report_column_visibilities` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `column_id` bigint(20) DEFAULT NULL,
  `visibility` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `report_data`
--

CREATE TABLE `report_data` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `column_id` bigint(20) DEFAULT NULL,
  `date` varchar(20) DEFAULT NULL,
  `value` varchar(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `telegram_link_tokens`
--

CREATE TABLE `telegram_link_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `token_hash` varchar(255) NOT NULL COMMENT 'SHA-256 hash of the raw token',
  `expires_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `email` varchar(191) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `mobile_number` varchar(191) DEFAULT NULL,
  `user_name` varchar(191) DEFAULT NULL,
  `branch` varchar(100) DEFAULT NULL,
  `responsibility` varchar(100) DEFAULT NULL,
  `study` varchar(100) DEFAULT NULL,
  `man` varchar(100) DEFAULT NULL COMMENT 'kormi, sathi, sodosso',
  `password` varchar(191) DEFAULT NULL,
  `about_me` varchar(191) DEFAULT NULL,
  `photo` varchar(191) DEFAULT 'avatar.png',
  `role_id` int(10) UNSIGNED NOT NULL DEFAULT 4,
  `verified` tinyint(1) NOT NULL DEFAULT 1,
  `remember_token` varchar(100) DEFAULT NULL,
  `api_token` varchar(30) DEFAULT NULL,
  `telegram_user_id` varchar(64) DEFAULT NULL,
  `telegram_username` varchar(191) DEFAULT NULL,
  `telegram_linked_at` timestamp NULL DEFAULT NULL,
  `slug` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users_new`
--

CREATE TABLE `users_new` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `user_name` varchar(100) DEFAULT NULL,
  `mobile_number` varchar(100) DEFAULT NULL,
  `photo` varchar(191) DEFAULT 'avatar.png',
  `role_id` int(11) NOT NULL DEFAULT 4,
  `email` varchar(191) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(191) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_cache_clears`
--

CREATE TABLE `user_cache_clears` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_email_verifies`
--

CREATE TABLE `user_email_verifies` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `email` varchar(50) DEFAULT NULL,
  `code` varchar(10) DEFAULT NULL,
  `validated` tinyint(4) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_roles`
--

CREATE TABLE `user_roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `role_serial` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `yearly_plans`
--

CREATE TABLE `yearly_plans` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `year` varchar(191) DEFAULT NULL,
  `quran_days` int(11) DEFAULT NULL,
  `surah_name` varchar(191) DEFAULT NULL,
  `quran_ayat` int(11) DEFAULT NULL,
  `quran_avg_ayat` double(8,2) DEFAULT NULL,
  `quran_darz` int(11) DEFAULT NULL,
  `surah_meaning` int(11) DEFAULT NULL,
  `hadith_days` int(11) DEFAULT NULL,
  `hadith_topics` varchar(191) DEFAULT NULL,
  `hadith_memorize` varchar(191) DEFAULT NULL,
  `hadith_avg` double(8,2) DEFAULT NULL,
  `hadith_darz` int(11) DEFAULT NULL,
  `hadith_subjects` varchar(191) DEFAULT NULL,
  `literature_pages` int(11) DEFAULT NULL,
  `literature_islamic` int(11) DEFAULT NULL,
  `literature_others` int(11) DEFAULT NULL,
  `literature_book_name` varchar(191) DEFAULT NULL,
  `literature_book_note` varchar(191) DEFAULT NULL,
  `literature_book` text DEFAULT NULL,
  `literature_discussion` varchar(191) DEFAULT NULL,
  `general_book_days` int(11) DEFAULT NULL,
  `class_attendance` int(11) DEFAULT NULL,
  `attendance_total_days` int(11) DEFAULT NULL,
  `jamayat_namaz` varchar(191) DEFAULT NULL,
  `nafal_namaz` varchar(191) DEFAULT NULL,
  `dawat_days` int(11) DEFAULT NULL,
  `dawat_total_hours` double(8,2) DEFAULT NULL,
  `dawat_person` int(11) DEFAULT NULL,
  `org_work_days` int(11) DEFAULT NULL,
  `org_work_avg_hours` double(8,2) DEFAULT NULL,
  `contact_member` int(11) DEFAULT NULL,
  `contact_supporter` int(11) DEFAULT NULL,
  `school_student` int(11) DEFAULT NULL,
  `contact_vip` int(11) DEFAULT NULL,
  `contact_associate` int(11) DEFAULT NULL,
  `contact_friend` int(11) DEFAULT NULL,
  `contact_talent` int(11) DEFAULT NULL,
  `contact_worker` int(11) DEFAULT NULL,
  `contact_wellwisher` int(11) DEFAULT NULL,
  `contact_teacher` int(11) DEFAULT NULL,
  `distribution_islamic_literature` int(11) DEFAULT NULL,
  `distribution_chhatrasangbad` int(11) DEFAULT NULL,
  `class_routine` int(11) DEFAULT NULL,
  `distribution_kishor_paper` int(11) DEFAULT NULL,
  `distribution_perspective` int(11) DEFAULT NULL,
  `sticker_card` int(11) DEFAULT NULL,
  `distribution_english_paper` int(11) DEFAULT NULL,
  `distribution_porichiti` int(11) DEFAULT NULL,
  `gift_sms_email` int(11) DEFAULT NULL,
  `increase_member1` int(11) DEFAULT NULL,
  `increase_member2` varchar(191) DEFAULT NULL,
  `activist1` int(11) DEFAULT NULL,
  `activist2` varchar(191) DEFAULT NULL,
  `member_elect1` int(11) DEFAULT NULL,
  `member_elect2` varchar(191) DEFAULT NULL,
  `supporter1` int(11) DEFAULT NULL,
  `supporter2` varchar(191) DEFAULT NULL,
  `increase_sathi1` int(11) DEFAULT NULL,
  `increase_sathi2` varchar(191) DEFAULT NULL,
  `increase_friend1` int(11) DEFAULT NULL,
  `increase_friend2` varchar(191) DEFAULT NULL,
  `sathi_elect1` int(11) DEFAULT NULL,
  `sathi_elect2` varchar(191) DEFAULT NULL,
  `card_wisher1` int(11) DEFAULT NULL,
  `card_wisher2` varchar(191) DEFAULT NULL,
  `bm_given_date` varchar(100) DEFAULT NULL,
  `personal_increase` int(11) DEFAULT NULL,
  `student_welfare` int(11) DEFAULT NULL,
  `kolsi_hari` int(11) DEFAULT NULL,
  `baitulmal_total` int(11) DEFAULT NULL,
  `table_bank` double(8,2) DEFAULT NULL,
  `baitulmal_others` int(11) DEFAULT NULL,
  `self_criticism` int(11) DEFAULT NULL,
  `muharama_contact` int(11) DEFAULT NULL,
  `dawat_email` int(11) DEFAULT NULL,
  `computer_learning` int(11) DEFAULT NULL,
  `language_learning` int(11) DEFAULT NULL,
  `physical_exercise` int(11) DEFAULT NULL,
  `group_dawat` int(11) DEFAULT NULL,
  `nonmuslim_contact` int(11) DEFAULT NULL,
  `manifold_newspaper` int(11) DEFAULT NULL,
  `dawat_sms` int(11) DEFAULT NULL,
  `contact_organization` int(11) DEFAULT NULL,
  `manifold_others` varchar(191) DEFAULT NULL,
  `opinion` varchar(191) DEFAULT NULL,
  `report_checking` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `modarator_of_users`
--
ALTER TABLE `modarator_of_users`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `modarator_sugession_to_users`
--
ALTER TABLE `modarator_sugession_to_users`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `monthly_plans`
--
ALTER TABLE `monthly_plans`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `monthly_plans_user_id_month_unique` (`user_id`,`month`);

--
-- Indexes for table `monthly_reports`
--
ALTER TABLE `monthly_reports`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `monthly_plans_user_id_month_unique` (`user_id`,`month`);

--
-- Indexes for table `oauth_access_tokens`
--
ALTER TABLE `oauth_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_access_tokens_user_id_index` (`user_id`);

--
-- Indexes for table `oauth_auth_codes`
--
ALTER TABLE `oauth_auth_codes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_auth_codes_user_id_index` (`user_id`);

--
-- Indexes for table `oauth_clients`
--
ALTER TABLE `oauth_clients`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_clients_user_id_index` (`user_id`);

--
-- Indexes for table `oauth_personal_access_clients`
--
ALTER TABLE `oauth_personal_access_clients`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `oauth_refresh_tokens`
--
ALTER TABLE `oauth_refresh_tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_refresh_tokens_access_token_id_index` (`access_token_id`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD KEY `password_resets_email_index` (`email`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `report_columns`
--
ALTER TABLE `report_columns`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `report_column_visibilities`
--
ALTER TABLE `report_column_visibilities`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `report_data`
--
ALTER TABLE `report_data`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`),
  ADD KEY `column_id` (`column_id`);

--
-- Indexes for table `telegram_link_tokens`
--
ALTER TABLE `telegram_link_tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `telegram_link_tokens_token_hash_index` (`token_hash`),
  ADD KEY `telegram_link_tokens_user_id_index` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD UNIQUE KEY `telegram_user_id` (`telegram_user_id`);

--
-- Indexes for table `users_new`
--
ALTER TABLE `users_new`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD UNIQUE KEY `users_user_name_unique` (`user_name`),
  ADD UNIQUE KEY `users_mobile_number_unique` (`mobile_number`);

--
-- Indexes for table `user_cache_clears`
--
ALTER TABLE `user_cache_clears`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_email_verifies`
--
ALTER TABLE `user_email_verifies`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_roles`
--
ALTER TABLE `user_roles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `yearly_plans`
--
ALTER TABLE `yearly_plans`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `modarator_of_users`
--
ALTER TABLE `modarator_of_users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `modarator_sugession_to_users`
--
ALTER TABLE `modarator_sugession_to_users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `monthly_plans`
--
ALTER TABLE `monthly_plans`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `monthly_reports`
--
ALTER TABLE `monthly_reports`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `oauth_personal_access_clients`
--
ALTER TABLE `oauth_personal_access_clients`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `report_columns`
--
ALTER TABLE `report_columns`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `report_column_visibilities`
--
ALTER TABLE `report_column_visibilities`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `report_data`
--
ALTER TABLE `report_data`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `telegram_link_tokens`
--
ALTER TABLE `telegram_link_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users_new`
--
ALTER TABLE `users_new`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_cache_clears`
--
ALTER TABLE `user_cache_clears`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_email_verifies`
--
ALTER TABLE `user_email_verifies`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_roles`
--
ALTER TABLE `user_roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `yearly_plans`
--
ALTER TABLE `yearly_plans`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `telegram_link_tokens`
--
ALTER TABLE `telegram_link_tokens`
  ADD CONSTRAINT `telegram_link_tokens_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
