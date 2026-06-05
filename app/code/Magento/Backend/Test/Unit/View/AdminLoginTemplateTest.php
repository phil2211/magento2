<?php
/**
 * Copyright 2026 Adobe
 * All Rights Reserved.
 */
declare(strict_types=1);

namespace Magento\Backend\Test\Unit\View;

use PHPUnit\Framework\TestCase;

class AdminLoginTemplateTest extends TestCase
{
    public function testLoginTemplateIncludesPasswordVisibilityToggle(): void
    {
        $template = file_get_contents(
            __DIR__ . '/../../../view/adminhtml/templates/admin/login.phtml'
        );

        $this->assertStringContainsString('data-role="show-password"', $template);
        $this->assertStringContainsString('Magento_Backend/js/password-visibility-toggle', $template);
    }
}
