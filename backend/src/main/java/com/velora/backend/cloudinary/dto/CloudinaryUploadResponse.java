package com.velora.backend.cloudinary.dto;

public class CloudinaryUploadResponse {

    private String url;
    private String secureUrl;
    private String publicId;
    private String resourceType;
    private String format;

    public CloudinaryUploadResponse() {
    }

    public CloudinaryUploadResponse(
            String url,
            String secureUrl,
            String publicId,
            String resourceType,
            String format
    ) {
        this.url = url;
        this.secureUrl = secureUrl;
        this.publicId = publicId;
        this.resourceType = resourceType;
        this.format = format;
    }

    public String getUrl() {
        return url;
    }

    public String getSecureUrl() {
        return secureUrl;
    }

    public String getPublicId() {
        return publicId;
    }

    public String getResourceType() {
        return resourceType;
    }

    public String getFormat() {
        return format;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public void setSecureUrl(String secureUrl) {
        this.secureUrl = secureUrl;
    }

    public void setPublicId(String publicId) {
        this.publicId = publicId;
    }

    public void setResourceType(String resourceType) {
        this.resourceType = resourceType;
    }

    public void setFormat(String format) {
        this.format = format;
    }
}